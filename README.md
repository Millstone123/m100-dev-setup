# Dev Preflight — Signed Startup Script

This repo runs a **preflight script before `npm start`**. The script is hosted
centrally on our internal server (`m100.cloud`) so the platform team can update
it on the fly, but every developer machine **cryptographically verifies** the
script before it runs. If the downloaded script wasn't signed by us, it is not
executed and `npm start` is blocked.

This document explains how the key system works, where each key lives, and how
integrity is checked — so you can trust what runs on your machine.

---

## TL;DR for developers

1. Be on the VPN (the script host, `m100.cloud`, is firewalled and VPN-only).
2. Install [`minisign`](https://jedisct1.github.io/minisign/) (one-time, see below).
3. `npm install`, then `npm start` as usual.

On every `npm start`, a `prestart` hook downloads the current preflight script
from `m100.cloud`, verifies its signature against a **public key committed in
this repo**, and only runs it if verification passes. You don't have to do
anything extra — but if you ever see a `BLOCKED: signature verification FAILED`
message, **stop and report it in #platform-eng**. That message means the script
served to you did not match our signing key.

---

## The trust model: two keys, and why they're different

The security of this whole setup rests on there being **two** keys that are
*not* interchangeable:

| Key | What it does | Where it lives | Secret? |
|-----|--------------|----------------|---------|
| **Private key** (`preflight.key`) | *Creates* signatures | CI secret store / vault only — **never** on the web server, **never** in the repo | **Yes — guard it like a prod credential** |
| **Public key** (`preflight.pub`) | *Verifies* signatures | Committed in this repo at `scripts/preflight.pub` | No — safe to publish |

The public key **cannot create signatures** and **cannot forge anything**. It
can only answer one yes/no question: *"Was this exact file signed by whoever
holds the matching private key?"* That's why it's safe to commit and hand to
every developer.

The private key is the only thing that can produce a signature our public key
will accept. It lives exclusively in our CI/vault. It is the single secret the
entire scheme protects.

---

## Where integrity is checked (the important part)

Integrity is checked **locally, on your machine, against the public key that
came from git — not from the server.**

That separation is the whole point. The script (`preflight.sh`) and its
signature (`preflight.sh.minisig`) both come from `m100.cloud` and can change
whenever the platform team pushes an update. The **public key never comes from
the server** — it arrives with your `git clone` and sits in `scripts/preflight.pub`.

Here's the flow on every `npm start`:

```
YOUR MACHINE (from git clone)                 m100.cloud (VPN-only, firewalled)
──────────────────────────────               ─────────────────────────────────
scripts/preflight.pub   ◄── committed         preflight.sh          ◄─ signed in CI
scripts/run-preflight.mjs                      preflight.sh.minisig  ◄─ by the PRIVATE key
        │                                              │
        │ 1. fetch to disk (not pipe):                 │
        │      preflight.sh          ◄─────────────────┤
        │      preflight.sh.minisig  ◄─────────────────┘
        │
        │ 2. verify downloaded script against the
        │    COMMITTED public key:
        ▼
   minisign -V -p scripts/preflight.pub -m preflight.sh
        │
        ├── signature valid   ──► 3. run the script
        └── signature invalid ──► BLOCK: exit non-zero, npm start stops,
                                   nothing is executed
```

### Why this is safe even if `m100.cloud` is compromised

Suppose an attacker fully owns the web server and swaps in a malicious
`preflight.sh`. To get your machine to run it, they'd need a `.minisig` that
verifies against **your committed public key** — and producing that requires the
**private key**, which is not on the server. So their tampered script fails
verification, `run-preflight.mjs` exits non-zero, and `npm start` is blocked.
The attacker got code onto the server but **not onto developer machines**.

### The one way to break this (don't do it)

If you ever fetched the public key *from `m100.cloud`* at verify time, you'd
throw away all the protection: an attacker who owns the server would just serve
their own script, sign it with their own key, and serve their own public key —
and everything would "verify." **The verifying key must arrive through a
different, trusted channel (git) than the thing being verified (the URL).** That
channel separation *is* the security. This is why `scripts/preflight.pub` is
committed and must never be downloaded at runtime.

---

## Files in this repo

```
scripts/
  preflight.pub        # committed public key — used to verify. Safe to share.
  run-preflight.mjs     # fetch + verify + run, fail-closed. Invoked by prestart.
package.json            # wires prestart -> run-preflight.mjs
```

### `package.json`

```json
{
  "scripts": {
    "prestart": "node scripts/run-preflight.mjs",
    "start": "node server.js"
  }
}
```

npm automatically runs `prestart` before `start`, so this fires on every
`npm start` with nothing extra to remember.

### `scripts/run-preflight.mjs`

This is the code that does the fetch, the verify, and the fail-closed exit. It
**downloads to a file** (never pipes to a shell), **verifies before running**,
and **blocks `npm start` on any failure** — including not being able to reach
the server (i.e. you're off the VPN).

```js
#!/usr/bin/env node
import { execFileSync } from 'node:child_process';
import { writeFileSync, mkdtempSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const BASE_URL = 'https://m100.cloud';
const SCRIPT_URL = `${BASE_URL}/preflight.sh`;
const SIG_URL = `${BASE_URL}/preflight.sh.minisig`;
const PUBKEY = fileURLToPath(new URL('./preflight.pub', import.meta.url));
const FETCH_TIMEOUT_MS = 10_000;

function fail(msg) {
  console.error(`\n[preflight] BLOCKED: ${msg}`);
  console.error('[preflight] npm start aborted. Nothing was executed.\n');
  process.exit(1);
}

async function fetchToFile(url, dest) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), FETCH_TIMEOUT_MS);
  try {
    const res = await fetch(url, { signal: controller.signal });
    if (!res.ok) throw new Error(`${url} -> HTTP ${res.status}`);
    writeFileSync(dest, Buffer.from(await res.arrayBuffer()));
  } finally {
    clearTimeout(timer);
  }
}

// 1. Download the script AND its signature to a temp dir (never pipe to a shell).
const dir = mkdtempSync(join(tmpdir(), 'preflight-'));
const scriptPath = join(dir, 'preflight.sh');
const sigPath = join(dir, 'preflight.sh.minisig'); // must sit next to the script

try {
  await fetchToFile(SCRIPT_URL, scriptPath);
  await fetchToFile(SIG_URL, sigPath);
} catch (err) {
  fail(`could not reach ${BASE_URL} — are you on the VPN? (${err.message})`);
}

// 2. Verify the downloaded script against the COMMITTED public key.
//    minisign finds preflight.sh.minisig automatically because it sits
//    next to preflight.sh with the matching name.
try {
  execFileSync('minisign', ['-V', '-p', PUBKEY, '-m', scriptPath], {
    stdio: ['ignore', 'ignore', 'pipe'],
  });
} catch {
  fail('signature verification FAILED — the downloaded script does not match '
     + 'our signing key. It was NOT run. Report this in #platform-eng.');
}

// 3. Only now, run it. Fail closed if it errors.
try {
  execFileSync('bash', [scriptPath], { stdio: 'inherit' });
} catch (err) {
  fail(`preflight script exited with an error (code ${err.status ?? '?'}).`);
}

console.log('[preflight] OK — verified and ran successfully.');
```

---

## One-time developer setup

Install `minisign`:

```bash
# macOS
brew install minisign

# Debian/Ubuntu
sudo apt-get install minisign

# verify it's on PATH
minisign -v
```

Make sure you're connected to the VPN before running `npm start`, since
`m100.cloud` is firewalled and unreachable otherwise. (If you're off the VPN,
preflight fails closed with a clear message — it won't run stale or partial
code.)

---

## Maintainer setup (platform team)

### 1. Generate the keypair (once)

```bash
# -W creates a passwordless private key so CI can sign non-interactively.
# The key's protection then comes entirely from your secret store — treat it
# accordingly. If you prefer a passphrase, drop -W and inject the passphrase
# in CI via stdin.
minisign -G -W -p scripts/preflight.pub -s preflight.key
```

- Commit `scripts/preflight.pub` to this repo.
- Move `preflight.key` into the CI secret store / vault. **Do not commit it. Do
  not put it on `m100.cloud`.** Delete your local copy once it's stored.

### 2. Sign on every update (in CI, whenever the script changes)

```bash
# preflight.key is injected from the secret store at build time.
minisign -S -s preflight.key -m preflight.sh
# produces preflight.sh.minisig

# publish BOTH files to the server
scp preflight.sh preflight.sh.minisig deploy@m100.cloud:/var/www/preflight/
```

Because verification pins the **signer**, not the file contents, you can change
`preflight.sh` as often as you like — every dev picks up the new version on
their next `npm start`, and nobody has to touch the repo. The committed public
key stays put.

---

## Operational notes

- **`m100.cloud` is VPN-only and firewalled.** Keep it that way. Authentication
  on the endpoint is defense-in-depth; the signature check is what actually
  protects developer machines, but you still don't want the script world-readable
  or the host world-reachable.
- **Guard the private key above all else.** The entire trust model reduces to
  "only we hold the private key." Store it in the secret manager with tight
  access, rotate it on any suspicion of exposure, and never let it land on the
  web server (the one box most exposed to compromise).
- **Fail closed, always.** `run-preflight.mjs` exits non-zero on fetch failure,
  verification failure, or script error. `npm start` should never proceed on a
  failed or unverified preflight.
- **Fetch to disk, never pipe.** The exact bytes that ran are in a temp file you
  can inspect or log — not vanished through `curl | bash`.

### Key rotation

If the private key is ever exposed:

1. Generate a new keypair.
2. Commit the new `scripts/preflight.pub` (a one-line, reviewable change).
3. Re-sign `preflight.sh` with the new private key and republish.
4. Store the new private key; destroy the old one everywhere.

Rotation is the *only* time the public key changes, and because it goes through
a normal reviewed commit, the change is visible and deliberate.

---

## Residual risk (know what you're accepting)

Because the script is fetched live, every developer runs whatever the latest
**signed** version is. This means anyone holding the private key can push code
to every developer machine. That is inherent to "changeable on the fly" — the
tradeoff you're choosing is central live control. This setup makes that control
**authenticated and tamper-evident** rather than open: server compromise alone
can't push code, only the private-key holder can. Guard the key, log signed
releases, and this is a sound tradeoff.

---

## Troubleshooting

| Message | Meaning | What to do |
|---------|---------|------------|
| `could not reach m100.cloud — are you on the VPN?` | Fetch failed/timed out | Connect to the VPN, retry |
| `signature verification FAILED` | Downloaded script didn't match the committed public key | **Stop. Report in #platform-eng.** Do not bypass. |
| `preflight script exited with an error` | Script ran but returned non-zero | Read its output above; usually an env/config issue |
| `minisign: command not found` | minisign not installed | See "One-time developer setup" |
