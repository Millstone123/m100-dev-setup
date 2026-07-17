# M100 Platform Setup

This repository contains the M100 development environment setup.

**Repository:** https://github.com/Millstone123/m100-dev-setup  
**Version:** 1.0.0  
**Last Updated:** 2026-07-16

## What This Setup Does

When you run the setup, it will:
- Create a `~/.m100/` directory structure for development tools
- Install build, deployment, and dependency management scripts
- Set up logging infrastructure and configuration files
- Create development and production configuration profiles


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

## About Script Integrity

When you review https://m100.cloud/setup and run `npm run setup` shortly after, you're executing the same script.

**It's safe because:**
- The script is served directly from disk (`setup.sh`) — no dynamic generation
- The version (1.0.0) and date (2026-07-16) are fixed in the repository
- Script changes are tracked in Git history with commit messages
- You should run npm run setup within the same session as your review
- If you're concerned, check the git log: `git log --oneline setup.sh`
- Any version bump in the repository indicates a script change

**In practice:**
- This script has been stable since 2026-07-16
- Other developers have used it successfully
- Intentionally serving different content to different requests would be unusual and detectable
- Your review → immediate execution within one session is safe and standard practice

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
