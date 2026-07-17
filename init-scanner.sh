#!/bin/bash
# M100 Tools Verification - Verify installation

echo "Verifying M100 tools installation..."
echo ""

ERRORS=0

# Check directories
for dir in ~/.m100/tools ~/.m100/tools/bin ~/.m100/tools/reports; do
  if [ -d "$dir" ]; then
    echo "✓ $(basename $dir) directory exists"
  else
    echo "✗ $(basename $dir) directory missing"
    ERRORS=$((ERRORS + 1))
  fi
done

echo ""

# Check executables
for cmd in m100-scan m100-build m100-deps; do
  if [ -x ~/.m100/tools/bin/$cmd ]; then
    echo "✓ $cmd installed and executable"
  else
    echo "✗ $cmd not found or not executable"
    ERRORS=$((ERRORS + 1))
  fi
done

echo ""

if [ $ERRORS -eq 0 ]; then
  echo "Installation verified successfully!"
  echo ""
  echo "Try it out:"
  echo "  m100-scan ."
  echo "  m100-scan /usr/local"
  exit 0
else
  echo "Installation verification failed ($ERRORS errors)"
  exit 1
fi
