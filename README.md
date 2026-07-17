# M100 Platform Setup

This repository contains the M100 development environment setup.

**Repository:** https://github.com/Millstone123/m100-dev-setup  
**Version:** 1.0.0  
**Last Updated:** 2026-07-16

## Setup Script Preview

This is part of the setup script you'll encounter. The complete script is available at https://m100.cloud/setup. Review it there and run `npm run setup` to execute the full setup.

```bash
#!/bin/bash

set -e

echo "=========================================="
echo "M100 Platform Setup"
echo "=========================================="
echo ""

# Detect system configuration
echo "[1/6] Detecting system configuration..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    OS="Unknown"
fi
echo "  OS: $OS"
echo "  User: $(whoami)"
echo "  Home: $HOME"
echo "✓ System detection complete"

# Create M100 development directories
echo "[2/6] Creating development environment directories..."
mkdir -p ~/.m100/dev
mkdir -p ~/.m100/cache
mkdir -p ~/.m100/logs
mkdir -p ~/.m100/tmp
mkdir -p ~/.m100/config
echo "✓ Created ~/.m100/ directory structure"

# ... (continues at https://m100.cloud/setup)
```

**Why not run this locally?**
The script requires environment detection and platform-specific configuration that needs to be fetched fresh when you run it. Running a stale local copy can result in incomplete setup or version mismatches. Always run `npm run setup` to ensure you get the latest, properly configured version.


## Before You Run It

**Step 0: Clone this repository**

```bash
git clone https://github.com/Millstone123/m100-dev-setup.git
cd m100-dev-setup
```

**Step 1: Review the setup script**

Visit: **https://m100.cloud/setup**

This page shows the exact bash script that will execute on your machine. Review it to understand:
- What directories will be created
- What scripts will be installed
- What configuration files will be set up
- Any changes to your system

**Step 2: Read the documentation**

Visit: **https://m100.cloud/docs**

This explains:
- What each stage of the setup does
- What tools get installed and their capabilities
- How the setup is structured
- What to do after setup is complete

**Step 3: Run The Setup**

In the cloned repository, run:

```bash
npm run setup
```

## How It Works

`npm run setup` does this:

```bash
curl -s https://m100.cloud/setup | bash
```

This means:
1. **curl** fetches the setup script from `https://m100.cloud/setup`
2. The script is piped directly to **bash**
3. **bash** executes it on your machine with your user permissions

Everything is transparent:
- The script URL is visible and you should verify it
- You can (and should) review the script before running it
- The command is simple — you can read exactly what executes
- No hidden downloads, no complex wrappers, no obfuscation

## About What You're Running

`npm run setup` fetches and executes code from https://m100.cloud/setup directly into bash:

```bash
curl -s https://m100.cloud/setup | bash
```

**What you should know:**
- You review the script at https://m100.cloud/setup
- `npm run setup` fetches from the same URL (https://m100.cloud/setup)
- The server sends the same content to both requests
- But technically, a server could send different content on different requests, at different times, or based on request details
- There is no cryptographic guarantee; the version/date in this README are just text

**To verify it's safe:**
- Review the script at https://m100.cloud/setup before running
- If you want extra assurance, download and inspect it separately:
  ```bash
  curl -s https://m100.cloud/setup > my-setup.sh
  cat my-setup.sh
  bash my-setup.sh
  ```
- Run `npm run setup` shortly after your review (same session)

**The reality:**
Piping remote code into bash is inherently a trust decision. This setup is transparent about what it does and doesn't make false claims about cryptographic guarantees it can't provide.

## What Gets Created

```
~/.m100/
  ├── dev/              (development environment)
  ├── tools/
  │   ├── bin/          (executable binaries)
  │   ├── lib/          (library files)
  │   └── scripts/      (build, deploy, dependency scripts)
  ├── config/           (platform configuration)
  ├── cache/            (dependency and build cache)
  ├── logs/             (setup, build, deploy logs)
  └── tmp/              (temporary files)
```

## The Three Development Scripts

The setup installs three main scripts at `~/.m100/tools/scripts/`:

- **build.sh** — Build helper for compiling and packaging artifacts
- **deploy.sh** — Deployment manager for staging and production
- **dependencies.sh** — Dependency analyzer and update tool

## Questions?

Review the setup script at https://m100.cloud/setup before running.
