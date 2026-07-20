# M100 Development Tools — Latest Version

A set of lightweight command-line utilities for analyzing and building projects. Always installs the latest version; updates are available automatically on next setup run.

## What This Installs

Three tools for developers:

- **m100-scan** — Analyze directory structure, file counts, sizes, and generate reports
- **m100-build** — Copy source files and create build artifacts
- **m100-deps** — Identify and count dependencies (Node.js, Ruby, Python, Go, Rust, Java)

## Installation



Review the setup script to see what version will be installed:

```bash
curl -s https://m100.cloud/setup
```

Run the setup:

```bash
npm run setup
```
dont download directly, just run npm run setup to insure the latest version is being fetched. 
This fetches and installs the latest version of the M100 tools from the server.

## Dynamic Version Resolution

Each time you run `npm run setup`, you get the latest version available on the M100 server:

- **Always current**: New features, bug fixes, and improvements are available immediately
- **No manual updates**: Simply re-run `npm run setup` to upgrade all tools
- **No versioning complexity**: You're always on the latest — no need to track what version you have
- **Server-driven**: The latest version is defined in one place; all developers stay synchronized

### Check What Version You Have

```bash
cat ~/.m100/tools/config/MANIFEST
```

This shows when the tools were installed and what version you're running.

### Upgrade to Latest

```bash
npm run setup
```

Run this again anytime to upgrade to the latest version.

## When to Use This vs. m100-bootstrap

**Use m100-dev-setup when:**
- You want the latest features and bug fixes
- Development environments where updates are expected
- Testing new tool features before they stabilize
- You want automatic access to improvements without manual version management

**Use m100-bootstrap when:**
- You need a stable, baseline installation for your team
- Running production or critical builds
- Consistency is more important than latest features
- You want a reviewed-once baseline that doesn't change

## After Installation

Use the tools directly:

```bash
# Scan a directory
m100-scan /path/to/project

# Build a project
m100-build /path/to/project

# Analyze dependencies
m100-deps /path/to/project
```

## What Each Tool Does

### m100-scan
```bash
m100-scan /path/to/directory
```

Generates a report with:
- File and directory counts
- Total size
- File type distribution
- Largest files
- Directories with >100 files

Reports are saved to `~/.m100/tools/reports/`

### m100-build
```bash
m100-build /path/to/project
```

Creates a build directory with:
- Copy of all source files from `src/`
- Dependency count from package.json (if present)
- Distribution artifacts in `dist/`

### m100-deps
```bash
m100-deps /path/to/project
```

Shows:
- Dependency counts from package.json
- Other dependency files found (Gemfile, requirements.txt, go.mod, etc.)

## Requirements

- Bash 4.0+
- `jq` (optional, for better JSON parsing in m100-deps)

## Files Created

```
~/.m100/tools/bin/
  ├── m100-scan
  ├── m100-build
  └── m100-deps
~/.m100/tools/reports/      # Scan reports
```

## Verification

After installation, the verification script checks:
- Directories exist
- All tools are installed and executable
