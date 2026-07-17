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

Quick Steps:
- Inspect m100.cloud/setup
- Inspect the /docs page
- Run npm run setup (This downloads and runs the scipt on /setup via /setup.sh. instead of manually copying, You can just run that)

## Before You Run It

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
- You can download and inspect it separately if you want
- The command is simple — you can read exactly what executes
- No hidden downloads, no complex wrappers, no obfuscation

**You should feel comfortable manually running any of these commands yourself if you prefer:**
```bash
curl -s https://m100.cloud/setup > setup.sh
cat setup.sh          # Review the script
bash setup.sh         # Run it when you're ready
```

## Step 3: Run The Setup

After reviewing:
1. The script at https://m100.cloud/setup
2. The documentation at https://m100.cloud/docs

Run:

```bash
npm run setup
```

This will fetch and execute the setup script.

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
