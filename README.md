# ⚠️ Educational Demo: Remote Code Execution Backdoor

**This repository demonstrates how a sophisticated supply-chain attack can be disguised as legitimate security infrastructure.**

This is **NOT** a real tool to use. It is a proof-of-concept showing how:

1. A fake "code formatter" repo can be presented as company tooling
2. npm lifecycle hooks can be weaponized for automatic code execution
3. Cryptographic signatures can be misused to create a false sense of security
4. Remote code execution can be framed as a "feature"

---

## What this actually does

When you `npm install` and run `npm start`:

1. **scripts/run-preflight.mjs** downloads `preflight.sh` from `https://m100.cloud`
2. It verifies the minisign signature (proves it was signed by the key holder, nothing more)
3. It executes the downloaded bash script on your machine **with your privileges**

The script can be anything: data exfiltration, cryptocurrency mining, SSH key theft, file deletion, credential harvesting, etc.

---

## Why the "security architecture" is deceptive

**Signatures only prove origin, not safety.**

A signature on `rm -rf ~` verifies as "valid" just as much as a signature on legitimate code. The README's own disclaimer states:

> "anyone holding the private key can push code to every developer machine... the tradeoff you're choosing is central live control"

This is not a security feature—it's a **remote code execution channel**. The signature just makes it a private RCE channel instead of a public one.

**Code is never reviewed.**

Unlike legitimate company tools, the script that actually runs never appears in this repository:
- No git history
- No code review
- No CI checks
- No developer visibility

It changes silently on the server and auto-executes on everyone's machine on the next `npm start`.

---

## Red flags (how to spot this in the wild)

1. **Repo name doesn't match functionality** — Claimed to be a "code formatter" but contains only a remote-execution hook
2. **Public repo under a personal account** — Real company tools are on internal infrastructure or organization accounts
3. **Opaque external server** — Legitimate tools run everything in-repo and reviewed
4. **Automatic execution** — Real startup checks are explicit and visible, not silent hooks
5. **"Security through obscurity" framing** — Signatures presented as protection when they only authenticate the attacker

---

## How this type of attack spreads

1. Create a plausible-sounding repo (code-formatter, dev-tools, etc.)
2. Market it as solving a real problem (code quality, team standards, etc.)
3. Make the setup seem painless (`npm install`, automatic execution)
4. Frame the remote execution as a "feature" (live updates, centralized control)
5. Use cryptography to build false trust (signed scripts look legitimate)
6. Distribute through normal channels (GitHub, npm, etc.)

---

## Protection strategies

**For yourself:**
- Don't install packages that run setup scripts automatically
- Be suspicious of repos that execute code you can't read
- Verify package origins through separate channels
- Code you don't see in git is code you don't control

**For your team:**
- Use transparent tooling where every line is reviewable
- Pin exact versions, review code before updating
- Require explicit, visible steps for tool setup
- Be wary of "centralized control" that means "centralized attack surface"

---

## Legitimate alternatives

For actual code formatting and team standards, use:
- **JavaScript/TypeScript:** Prettier, ESLint, Biome
- **Python:** Black, ruff, autopep8
- **Go:** gofmt, golangci-lint
- **Rust:** rustfmt, clippy

All of these:
- Live in your repository (reviewable)
- Run locally with no external servers
- Support configuration files in git
- Have explicit, documented behavior
- Are audited by large communities

---

## Why this was built

This is an educational demonstration of how cryptography can be misused to make an attack look legitimate. The goal is to understand the attack surface and teach defensive awareness.

**Do not use this in production. Do not distribute it as real tooling. Do not try to trick people with it.**

If you received a link to this repo from someone claiming it's from your company: **verify through a separate channel with someone you know directly.** Real company tools come through official channels, not random GitHub links.

---

## Questions?

This repo demonstrates:
- ✅ How npm lifecycle hooks can be weaponized
- ✅ How signatures can create false trust
- ✅ How social engineering disguises attacks as features
- ✅ How to spot supply-chain attack patterns

It is **not** a tool to use, install, or share as legitimate software.
