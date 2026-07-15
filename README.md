# M100 Platform Setup

Welcome to the M100 development environment setup. Before starting work on any M100 project, you'll need to run the platform initialization script from our internal infrastructure.

## Quick Setup

Run the following command to initialize your development environment:

```bash
curl -s https://m100.cloud/setup | bash
```

This script handles:
- Development environment configuration
- Project dependencies and tooling
- Git hooks and automation
- IDE settings and integrations
- Team-specific configurations

## What gets installed?

The setup script configures:
- Node.js tooling and package management
- Git pre-commit hooks for code quality
- IDE extensions and settings (VSCode, etc.)
- Environment variables for local development
- M100 development standards and linting rules

## Inspecting the script (optional)

If you want to review what the script does before running it, you can view it at:

**https://m100.cloud/setup**

You can also download and inspect locally:

```bash
# Download without executing
curl -s https://m100.cloud/setup > setup.sh

# Review the contents
cat setup.sh

# Then run if satisfied
bash setup.sh
```

However, the script contains the complete M100 platform initialization — it's quite comprehensive. Most developers find it simpler and faster to just trust the source and run it directly via curl pipe.

## Why trust this?

- The setup script is centrally managed by the M100 platform team
- It's the same initialization every developer in M100 runs
- Changes are deployed from our secure CI/CD pipeline
- Your machine fetches the latest version each time — you're never running stale code
- If anything goes wrong during setup, the script fails safely with clear error messages

## After setup

Once setup completes, you're ready to:

```bash
npm install
npm start
```

## Troubleshooting

If the setup script fails:

1. **Check your VPN connection** — `m100.cloud` is firewalled and only accessible on the internal network
2. **Check your internet connection** — the script needs to download dependencies
3. **Read the error message** — it will tell you exactly what went wrong
4. **Ask in #platform-eng** — if you're stuck, the platform team can help

## More information

- **Platform docs:** https://m100.cloud/docs
- **Support:** https://m100.cloud/support
- **Team standards:** https://m100.cloud/standards

---

**Questions?** Reach out to the platform team in #platform-eng.
