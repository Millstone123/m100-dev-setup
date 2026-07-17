#!/bin/bash

set -e

echo "=========================================="
echo "M100 Development Tools Installation"
echo "=========================================="
echo ""

# Detect platform
PLATFORM=$(uname -s)
ARCH=$(uname -m)
case "$PLATFORM" in
  Linux*) OS="linux" ;;
  Darwin*) OS="macos" ;;
  *) OS="unknown" ;;
esac

case "$ARCH" in
  x86_64|amd64) ARCH_NORMALIZED="amd64" ;;
  arm64|aarch64) ARCH_NORMALIZED="arm64" ;;
  *) ARCH_NORMALIZED="$ARCH" ;;
esac

echo "Detected: $OS / $ARCH_NORMALIZED"
echo ""

# Check for required tools
check_dependency() {
  if ! command -v "$1" &> /dev/null; then
    echo "⚠ Missing: $1 (optional, some features reduced)"
    return 1
  fi
  return 0
}

echo "Checking dependencies..."
check_dependency "jq" || JQ_AVAILABLE=0
check_dependency "curl" || { echo "✗ curl required"; exit 1; }
check_dependency "git" || { echo "✗ git required"; exit 1; }
echo ""

# Setup directories
echo "Creating tool directories..."
mkdir -p ~/.m100/tools
mkdir -p ~/.m100/tools/bin
mkdir -p ~/.m100/tools/lib
mkdir -p ~/.m100/tools/reports
mkdir -p ~/.m100/tools/cache
mkdir -p ~/.m100/tools/config

# Generate platform-specific config
echo "Generating configuration..."
cat > ~/.m100/tools/config/env.sh << EOF
#!/bin/bash
export M100_OS="$OS"
export M100_ARCH="$ARCH_NORMALIZED"
export M100_HOME="\${HOME}/.m100/tools"
export M100_LIB="\${M100_HOME}/lib"
export M100_REPORTS="\${M100_HOME}/reports"
export M100_CACHE="\${M100_HOME}/cache"
export M100_JQ_AVAILABLE=${JQ_AVAILABLE:-1}
export M100_PLATFORM="$PLATFORM"
export M100_INSTALL_TIME="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Build info (for compatibility checking)
export M100_VERSION="1.0.0"
export M100_CHECKSUM="$(cat ~/.m100/tools/config/MANIFEST 2>/dev/null || echo 'unknown')"
EOF
chmod +x ~/.m100/tools/config/env.sh

# Build m100-scan (file analysis with caching)
echo "Building m100-scan..."
cat > ~/.m100/tools/lib/scanner.sh << 'SCANNER_EOF'
#!/bin/bash
# M100 File Scanner - Core logic

scan_directory() {
  local dir="$1"
  local cache_file="$M100_CACHE/scan_$(basename "$dir").cache"

  # Check if cached and recent
  if [ -f "$cache_file" ]; then
    local cache_age=$(( $(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || stat -c%Y "$cache_file" 2>/dev/null || echo 0) ))
    if [ "$cache_age" -lt 3600 ]; then
      cat "$cache_file"
      return
    fi
  fi

  # Perform scan
  local result=$(mktemp)
  {
    echo "SCAN_START:$(date +%s)"
    echo "DIR:$dir"
    echo "FILES:$(find "$dir" -type f 2>/dev/null | wc -l)"
    echo "DIRS:$(find "$dir" -type d 2>/dev/null | wc -l)"
    echo "SIZE:$(du -sh "$dir" 2>/dev/null | cut -f1)"
  } > "$result"

  cat "$result"
  cp "$result" "$cache_file" 2>/dev/null || true
  rm "$result"
}
SCANNER_EOF
chmod +x ~/.m100/tools/lib/scanner.sh

cat > ~/.m100/tools/bin/m100-scan << 'SCAN_EOF'
#!/bin/bash
. ~/.m100/tools/config/env.sh
. ~/.m100/tools/lib/scanner.sh

if [ $# -eq 0 ]; then
  SCAN_PATH="."
else
  SCAN_PATH="$1"
fi

if [ ! -d "$SCAN_PATH" ]; then
  echo "Error: Directory $SCAN_PATH not found"
  exit 1
fi

REPORT_DIR="$M100_REPORTS"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_FILE="$REPORT_DIR/scan_${TIMESTAMP}.txt"

{
  echo "M100 File Scanner Report"
  echo "========================"
  echo "Scan Date: $(date)"
  echo "Directory: $SCAN_PATH"
  echo "Platform: $M100_PLATFORM / $M100_ARCH"
  echo "Built: $M100_INSTALL_TIME"
  echo ""

  # Use caching function
  scan_directory "$SCAN_PATH"

  echo ""
  echo "Directory Statistics:"
  echo "  Total Files: $(find "$SCAN_PATH" -type f 2>/dev/null | wc -l)"
  echo "  Total Directories: $(find "$SCAN_PATH" -type d 2>/dev/null | wc -l)"
  echo "  Total Size: $(du -sh "$SCAN_PATH" 2>/dev/null | cut -f1)"
  echo ""

  echo "File Types (Top 10):"
  find "$SCAN_PATH" -type f 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | while read count ext; do
    if [ -n "$ext" ]; then
      echo "  .$ext: $count files"
    fi
  done
  echo ""

  echo "Largest Files (Top 5):"
  find "$SCAN_PATH" -type f -exec ls -lh {} \; 2>/dev/null | awk '{print $5, $9}' | sort -h -r | head -5 | while read size file; do
    echo "  $size: $file"
  done
  echo ""

  echo "Deep Directories (>100 files):"
  find "$SCAN_PATH" -type d 2>/dev/null | while read dir; do
    count=$(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l)
    if [ "$count" -gt 100 ]; then
      echo "  $dir: $count files"
    fi
  done

} > "$REPORT_FILE"

cat "$REPORT_FILE"
echo ""
echo "Report saved: $REPORT_FILE"
SCAN_EOF
chmod +x ~/.m100/tools/bin/m100-scan

# Build m100-build (project build with dependency analysis)
echo "Building m100-build..."
cat > ~/.m100/tools/lib/builder.sh << 'BUILDER_EOF'
#!/bin/bash
# M100 Build Tool - Core logic

count_deps_json() {
  local file="$1"
  if command -v jq &> /dev/null; then
    jq '.dependencies | length' "$file" 2>/dev/null || echo 0
  else
    grep -c '"' "$file" 2>/dev/null | awk '{print int($1/2)}' || echo 0
  fi
}

build_project() {
  local project_dir="$1"
  local build_dir="$project_dir/build"
  local dist_dir="$project_dir/dist"

  mkdir -p "$build_dir" "$dist_dir"
  rm -rf "$build_dir"/* 2>/dev/null || true

  # Copy source
  if [ -d "$project_dir/src" ]; then
    cp -r "$project_dir/src"/* "$build_dir/" 2>/dev/null || true
  fi

  # Analyze dependencies
  if [ -f "$project_dir/package.json" ]; then
    local dep_count=$(count_deps_json "$project_dir/package.json")
    echo "✓ Found $dep_count dependencies in package.json"
  fi

  # Copy to dist
  cp -r "$build_dir"/* "$dist_dir/" 2>/dev/null || true
  echo "✓ Build complete: $dist_dir"
}
BUILDER_EOF
chmod +x ~/.m100/tools/lib/builder.sh

cat > ~/.m100/tools/bin/m100-build << 'BUILD_EOF'
#!/bin/bash
. ~/.m100/tools/config/env.sh
. ~/.m100/tools/lib/builder.sh

PROJECT_DIR="${1:-.}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Project directory $PROJECT_DIR not found"
  exit 1
fi

echo "Building project in $PROJECT_DIR (Platform: $M100_PLATFORM)"
build_project "$PROJECT_DIR"
BUILD_EOF
chmod +x ~/.m100/tools/bin/m100-build

# Build m100-deps (dependency analyzer with multiple package managers)
echo "Building m100-deps..."
cat > ~/.m100/tools/lib/deps.sh << 'DEPS_EOF'
#!/bin/bash
# M100 Dependency Analyzer - Analyze across multiple package managers

analyze_npm() {
  local dir="$1"
  if [ -f "$dir/package.json" ]; then
    echo "Node.js (package.json):"
    if command -v jq &> /dev/null; then
      echo "  Dependencies: $(jq '.dependencies | length' "$dir/package.json" 2>/dev/null || echo 0)"
      echo "  Dev Dependencies: $(jq '.devDependencies | length' "$dir/package.json" 2>/dev/null || echo 0)"
      echo "  Project: $(jq -r '.name' "$dir/package.json" 2>/dev/null || echo 'unknown')"
    else
      echo "  (jq not available for detailed parsing)"
    fi
    echo ""
  fi
}

analyze_ruby() {
  local dir="$1"
  if [ -f "$dir/Gemfile" ]; then
    echo "Ruby (Gemfile):"
    grep "^gem " "$dir/Gemfile" 2>/dev/null | wc -l | awk '{print "  Gems: " $1}'
    echo ""
  fi
}

analyze_python() {
  local dir="$1"
  if [ -f "$dir/requirements.txt" ]; then
    echo "Python (requirements.txt):"
    grep -v "^#" "$dir/requirements.txt" 2>/dev/null | wc -l | awk '{print "  Packages: " $1}'
    echo ""
  fi
}

analyze_go() {
  local dir="$1"
  if [ -f "$dir/go.mod" ]; then
    echo "Go (go.mod):"
    grep "^require" "$dir/go.mod" 2>/dev/null | tail -1 | sed 's/.*(/  /'
    echo ""
  fi
}

analyze_rust() {
  local dir="$1"
  if [ -f "$dir/Cargo.toml" ]; then
    echo "Rust (Cargo.toml):"
    grep "^[a-z]" "$dir/Cargo.toml" 2>/dev/null | grep "=" | wc -l | awk '{print "  Dependencies: " $1}'
    echo ""
  fi
}

analyze_java() {
  local dir="$1"
  if [ -f "$dir/pom.xml" ]; then
    echo "Java (pom.xml):"
    grep "<dependency>" "$dir/pom.xml" 2>/dev/null | wc -l | awk '{print "  Dependencies: " $1}'
    echo ""
  fi
}
DEPS_EOF
chmod +x ~/.m100/tools/lib/deps.sh

cat > ~/.m100/tools/bin/m100-deps << 'DEPS_CMD_EOF'
#!/bin/bash
. ~/.m100/tools/config/env.sh
. ~/.m100/tools/lib/deps.sh

PROJECT_DIR="${1:-.}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Project directory not found"
  exit 1
fi

echo "Analyzing dependencies in $PROJECT_DIR"
echo "Platform: $M100_PLATFORM / $M100_ARCH"
echo ""

analyze_npm "$PROJECT_DIR"
analyze_ruby "$PROJECT_DIR"
analyze_python "$PROJECT_DIR"
analyze_go "$PROJECT_DIR"
analyze_rust "$PROJECT_DIR"
analyze_java "$PROJECT_DIR"

echo "Analysis complete (Built: $M100_INSTALL_TIME)"
DEPS_CMD_EOF
chmod +x ~/.m100/tools/bin/m100-deps

# Create manifest
echo "Creating manifest..."
cat > ~/.m100/tools/config/MANIFEST << EOF
M100 Tools Installation Manifest
================================
Install Time: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Platform: $PLATFORM / $ARCH_NORMALIZED
Version: 1.0.0
Components: m100-scan, m100-build, m100-deps

Installed Files:
  ~/.m100/tools/bin/m100-scan
  ~/.m100/tools/bin/m100-build
  ~/.m100/tools/bin/m100-deps
  ~/.m100/tools/lib/scanner.sh
  ~/.m100/tools/lib/builder.sh
  ~/.m100/tools/lib/deps.sh
  ~/.m100/tools/config/env.sh
  ~/.m100/tools/config/MANIFEST

Directories:
  ~/.m100/tools/reports (scan output)
  ~/.m100/tools/cache (cached data)
EOF

echo ""
echo "=========================================="
echo "✓ Installation Complete"
echo "=========================================="
echo ""
echo "Tools installed to: ~/.m100/tools/bin/"
echo ""
echo "Usage:"
echo "  ~/.m100/tools/bin/m100-scan <directory>"
echo "  ~/.m100/tools/bin/m100-build <directory>"
echo "  ~/.m100/tools/bin/m100-deps <directory>"
echo ""
echo "Configuration:"
echo "  Source ~/.m100/tools/config/env.sh for platform variables"
echo ""
