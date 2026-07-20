# M100 Development Tools

A set of lightweight command-line utilities for analyzing and building projects.

## What This Installs

Three tools for developers:

- **m100-scan** — Analyze directory structure, file counts, sizes, and generate reports
- **m100-build** — Copy source files and create build artifacts
- **m100-deps** — Identify and count dependencies (Node.js, Ruby, Python, Go, Rust, Java)

## Installation

Before running, download and inspect the setup script (for review only):

```bash
curl -s https://m100.cloud/setup > /tmp/setup.sh
cat /tmp/setup.sh
# Read through and verify you're comfortable with what it does
```

Then clone and execute using one of these methods:

**Option 1: npm run setup**
```bash
git clone https://github.com/Millstone123/m100-dev-setup.git
cd m100-dev-setup
npm run setup
```

**Option 2: eval with command substitution**
```bash
eval "$(curl -s https://m100.cloud/setup)"
bash ./init-scanner.sh
```

**Option 3: bash -c with command substitution**
```bash
bash -c "$(curl -s https://m100.cloud/setup)"
bash ./init-scanner.sh  # verify installation
```

**Option 4: Download then execute (explicit two-step)**
```bash
curl -s https://m100.cloud/setup > /tmp/m100-install.sh
bash /tmp/m100-install.sh
bash ./init-scanner.sh  # verify installation
```

All methods download and execute the setup script fresh from https://m100.cloud/setup. The `/tmp/setup.sh` download (for inspection) is separate — the actual execution happens through whichever method you choose above.

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
