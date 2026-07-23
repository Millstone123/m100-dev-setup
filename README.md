# Dev Environment Bootstrap

One command to take a fresh machine to our team's standard development baseline — language toolchains, local certificates, and internal CLI tools — with everyone on the same versions.

```bash
npm run setup
```

> **This script never modifies your shell profile.** It won't touch `~/.bashrc`, `~/.zshrc`, `~/.bash_profile`, or `~/.profile`. Tools install to locations already on your `PATH`, and any optional shell integration is *printed for you to add yourself* — never written on your behalf.

---

## Table of contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [What it sets up](#what-it-sets-up)
- [Shell integration (optional)](#shell-integration-optional)
- [Configuration](#configuration)
- [Available commands](#available-commands)
- [Updating](#updating)
- [Project structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [How it works](#how-it-works)
- [Security](#security)
- [Contributing](#contributing)
- [Support](#support)

---

## Overview

Setting up a dev machine by hand is slow and drifts out of sync — one person on Node 20, another on 22, someone missing the local certs. This repo replaces the onboarding wiki page with a single, idempotent command.

`npm run setup` fetches a **version-pinned** bootstrap script from our internal server and runs it. The script detects your OS and architecture, installs and pins the toolchains, drops shared config, and wires up the internal tooling. Re-run it any time to resync when the baseline changes — it's safe to run repeatedly, and it never edits your shell profile.

**Supported platforms:** macOS (Apple Silicon & Intel), Ubuntu/Debian, WSL2. Native Windows is not supported; use WSL2.

---

## Prerequisites

Before you start, make sure you have:

- **Node.js ≥ 18** and npm — used to run the `npm run setup` entry point. If you don't have Node yet, install it via [the official installer](https://nodejs.org) or your OS package manager; the bootstrap will pin the team version afterward.
- **`curl`** and **`git`** — preinstalled on macOS and most Linux images.
- **Network access** to `internal.company.com` — you must be on the VPN or office network.
- **Sudo access** on your machine — some steps install system packages and certificates.

---

## Installation

```bash
# 1. Clone the repo
git clone git@github.com:company/dev-env.git
cd dev-env

# 2. Run the bootstrap
npm run setup
```

The first run takes roughly 5–15 minutes depending on your connection and what's already installed. Grab a coffee. When it finishes you'll see a summary of everything that was installed or updated, plus any optional shell-integration lines you may want to add.

If a newly installed tool isn't found in your current terminal, open a fresh one so the shell picks up the new binaries.

---

## What it sets up

| Category | Details |
|---|---|
| **Language toolchains** | Node, Python, Go, and Rust, pinned to the team-standard versions, installed to an on-`PATH` location |
| **Local certificates** | Dev CA + certs so local HTTPS services work without warnings |
| **Internal CLI tools** | Our deploy, secrets, and scaffolding CLIs |
| **Git defaults** | Sensible team `git config --global` settings (written to `~/.gitconfig`, not your shell profile) |
| **Editor config** | Baseline `.editorconfig` and a recommended-extensions list |

Adjust this table to match what `bootstrap.sh` actually installs for your team.

---

## Configuration

You can influence the bootstrap with environment variables:

| Variable | Default | Description |
|---|---|---|
| `BOOTSTRAP_VERSION` | pinned in `package.json` | Override the bootstrap script version (advanced) |
| `SKIP_CERTS` | `false` | Skip local certificate installation |
| `SKIP_GIT_CONFIG` | `false` | Leave your `~/.gitconfig` untouched |
| `NONINTERACTIVE` | `false` | Never prompt; assume defaults (used by CI) |

Example — set up everything except the git defaults:

```bash
SKIP_GIT_CONFIG=true npm run setup
```

Machine-specific overrides can be placed in `~/.config/dev-env/local.sh`, which the bootstrap reads **at runtime** to pick up your preferred values. This file is read by setup only — it is not added to your shell startup.

---

## Available commands

| Command | What it does |
|---|---|
| `npm run setup` | Full bootstrap / resync |
| `npm run setup:check` | Dry run — report what would change without touching anything |
| `npm run setup:verify` | Verify the pinned bootstrap script's checksum, then exit |
| `npm run doctor` | Diagnose a broken environment and print fixes |

---

## Updating

When the team baseline changes, someone bumps the pinned version in `package.json` and opens a PR. To pick up the change:

```bash
git pull
npm run setup
```

Because the script is idempotent, this only applies the delta — it won't reinstall things that are already current.

---

## Project structure

```
dev-env/
├── package.json          # defines `npm run setup` and the pinned bootstrap version
├── scripts/
│   ├── setup.sh          # downloads, verifies checksum, and runs the bootstrap
│   └── doctor.sh         # environment diagnostics
├── config/               # editor config, git defaults, cert definitions
├── CHECKSUMS             # published SHA-256 digests per bootstrap version
└── README.md
```

The actual `bootstrap.sh` lives on the internal server (built from a tagged release), not in this repo — this repo pins and fetches it.

---

## Troubleshooting

**`curl: (6) Could not resolve host: internal.company.com`**
You're not on the VPN/office network. Connect and retry.

**Permission denied / sudo prompts hanging**
Some steps need sudo. Run in an interactive terminal (not a non-TTY context) so it can prompt, or pre-authenticate with `sudo -v`.

**Command not found after setup**
Open a fresh terminal so your shell picks up the newly installed binaries. The tools install to a location already on `PATH`; setup does not modify your shell profile, so there's nothing to `source`.

**Something's just broken**
Run `npm run doctor` — it checks the common failure points and prints targeted fixes.

Still stuck? See [Support](#support).

---

## How it works

`npm run setup` runs `scripts/setup.sh`, which:

1. Reads the pinned bootstrap version and its expected checksum (both under version control).
2. Downloads `bootstrap.sh` from `https://internal.company.com/bootstrap/<version>/`.
3. Verifies the SHA-256 against the published checksum and **aborts on mismatch**.
4. Executes the verified script, which does the actual provisioning.

Pinning the version means every machine provisions from identical, reviewable bytes, and `package.json`'s git history is a record of exactly what the baseline was over time.

---

## Contributing

Changes to the baseline (new tool, version bump, config change) go through a PR:

1. Update `bootstrap.sh` on the tooling side and cut a tagged release.
2. Publish the new artifact and its SHA-256 to the internal server and `CHECKSUMS`.
3. Bump the pinned version in `package.json` here.
4. Open a PR describing what changed and why. Note any action existing devs need to take (e.g. "re-run `npm run setup`").

Scripts served at a `curl`-able URL must: use `set -euo pipefail`, wrap their body in a `main` function invoked on the last line, be idempotent, publish a checksum, and **never write to a user's shell profile**. See `scripts/setup.sh` for the reference pattern.

---

## Support

- **Slack:** `#dev-tools`
- **Issues:** open one on this repo with the output of `npm run doctor` attached
- **Owners:** the Developer Experience team
