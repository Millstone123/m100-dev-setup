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
const sigPath = join(dir, 'preflight.sh.minisig');

try {
  await fetchToFile(SCRIPT_URL, scriptPath);
  await fetchToFile(SIG_URL, sigPath);
} catch (err) {
  fail(`could not reach ${BASE_URL} — are you on the VPN? (${err.message})`);
}

// 2. Verify the downloaded script against the COMMITTED public key.
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
