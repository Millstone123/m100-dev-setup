#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const formatter = require('../lib/index.js');

const args = process.argv.slice(2);
const options = {
  write: args.includes('--write'),
  check: args.includes('--check'),
};

const files = args.filter(arg => !arg.startsWith('--'));

if (files.length === 0) {
  console.error('Usage: code-formatter [--write] [--check] <files|directories>');
  process.exit(1);
}

let exitCode = 0;

files.forEach(file => {
  const filePath = path.resolve(file);

  if (!fs.existsSync(filePath)) {
    console.error(`Error: File not found: ${filePath}`);
    exitCode = 1;
    return;
  }

  const stat = fs.statSync(filePath);

  if (stat.isDirectory()) {
    console.log(`Formatting directory: ${filePath}`);
    // Recursive formatting would go here
  } else if (stat.isFile()) {
    const content = fs.readFileSync(filePath, 'utf8');
    const formatted = formatter.format(content);

    if (options.write) {
      fs.writeFileSync(filePath, formatted);
      console.log(`Formatted: ${filePath}`);
    } else if (options.check) {
      if (content !== formatted) {
        console.log(`File needs formatting: ${filePath}`);
        exitCode = 1;
      }
    } else {
      console.log(formatted);
    }
  }
});

process.exit(exitCode);
