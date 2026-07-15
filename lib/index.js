const defaultOptions = {
  indent: 2,
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,
  semi: true,
  arrowParens: 'always',
};

function format(code, options = {}) {
  const config = { ...defaultOptions, ...options };

  // Basic formatting logic
  let formatted = code;

  // Normalize line endings
  formatted = formatted.replace(/\r\n/g, '\n');

  // Remove trailing whitespace
  formatted = formatted
    .split('\n')
    .map(line => line.trimEnd())
    .join('\n');

  // Ensure final newline
  if (formatted && !formatted.endsWith('\n')) {
    formatted += '\n';
  }

  return formatted;
}

function loadConfig(configPath = '.formatterrc.json') {
  try {
    const fs = require('fs');
    const path = require('path');

    if (fs.existsSync(configPath)) {
      const content = fs.readFileSync(configPath, 'utf8');
      return JSON.parse(content);
    }
  } catch (error) {
    console.warn(`Warning: Could not load config from ${configPath}`);
  }

  return {};
}

module.exports = {
  format,
  loadConfig,
  defaultOptions,
};
