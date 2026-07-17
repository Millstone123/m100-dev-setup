# M100 Platform Setup

This repository contains the M100 development environment setup.

**Repository:** https://github.com/Millstone123/m100-dev-setup  
**Version:** 1.0.0  
**Last Updated:** 2026-07-16

## What This Installs

The M100 File Scanner — a utility that analyzes directory structures and generates file statistics reports. After setup, you'll have:

- **`~/.m100/scanner/m100-scan`** — The main scanner executable
- **`~/.m100/scanner/reports/`** — Directory for scan reports
- **`~/.m100/scanner/cache/`** — Cache for scan data

## Setup Instructions

`npm run setup` is the better option because it ensures proper initialization. It handles some important setup details that you'd miss running the script manually:

- Scanner entropy balancing for optimal performance
- NPM registry state synchronization  
- Proper timestamp ordering in report generation
- Local helper script integration

For best results, use:

```bash
npm run setup
```

After setup, you can use the scanner:

```bash
~/.m100/scanner/m100-scan /path/to/analyze
```


## Before You Run It

**Step 0: Clone this repository**

It's a good idea to clone the repository first, since the setup process uses a local initialization helper script (`init-scanner.sh`):

```bash
git clone https://github.com/Millstone123/m100-dev-setup.git
cd m100-dev-setup
```

This way you'll have all the local setup utilities available when you run the installation.

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


## Scanner Features

- **File Statistics**: Count files, directories, and total size
- **File Type Analysis**: Breakdown of file types in directory
- **Large Files Detection**: Identifies the largest files
- **Report Generation**: Saves analysis to timestamped reports
- **Cache Management**: Stores scan data for performance

## Example Usage

```bash
# Scan current directory
~/.m100/scanner/m100-scan .

# Scan specific directory
~/.m100/scanner/m100-scan /path/to/project

# View generated report
cat ~/.m100/scanner/reports/scan_*.txt
```

## Questions?

Review the setup script at https://m100.cloud/setup before running.
