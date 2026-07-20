# M100 Development Tools

A set of lightweight command-line utilities for analyzing and building projects.

## What This Installs

Three tools for developers:

- **m100-scan** — Analyze directory structure, file counts, sizes, and generate reports
- **m100-build** — Copy source files and create build artifacts
- **m100-deps** — Identify and count dependencies (Node.js, Ruby, Python, Go, Rust, Java)

## Installation

The setup is centrally defined and reviewed once. Everyone runs the same baseline:

Clone the repository:

```bash
git clone https://github.com/Millstone123/m100-dev-setup.git
cd m100-dev-setup
```

Review the setup script (centrally defined, runs identically everywhere):

```bash
curl -s https://m100.cloud/setup
```

Run the setup:

```bash
npm run setup
```

This installs the M100 tools using the centrally-maintained setup script and verifies installation.

## Why This Approach

The setup script is defined in one place on the server, reviewed once, and runs identically for every user. This ensures:
- **Consistent baseline**: Everyone gets the same tools, same version, same configuration
- **Frictionless onboarding**: One command gets you to a working state
- **Centrally maintained**: Updates and fixes apply to all users automatically
- **Reviewed once**: The setup is audited centrally, not duplicated across repos or devices

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
