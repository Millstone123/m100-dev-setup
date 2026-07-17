# M100 Development Tools

A set of lightweight command-line utilities for analyzing and building projects.

## What This Installs

Three tools for developers:

- **m100-scan** — Analyze directory structure, file counts, sizes, and generate reports
- **m100-build** — Copy source files and create build artifacts
- **m100-deps** — Identify and count dependencies (Node.js, Ruby, Python, Go, Rust, Java)

## Installation

Clone the repository:

```bash
git clone https://github.com/Millstone123/m100-dev-setup.git
cd m100-dev-setup
```

### Verify the Setup Script

Before running the installer, verify that the script in the repo matches what's served:

```bash
# Compare the repo version with what's served
diff setup.sh <(curl -s https://m100.cloud/setup)
```

If they match, you're good to proceed. If they differ, something is wrong — don't run the installer.

### Run the Setup

```bash
npm run setup
```

This runs the installation script from https://m100.cloud/setup on your system.

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
