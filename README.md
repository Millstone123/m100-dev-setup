# M100 Platform Setup

Welcome to the M100 development environment setup. Before starting work on any M100 project, you need to initialize your development environment with scripts from our internal infrastructure at `m100.cloud`.

## Important: Inspect First

**All setup scripts must be reviewed before execution.** We take security seriously, so we require every developer to inspect the initialization script before running it.

### Step 1: Visit the setup page

Go to: **https://m100.cloud**

This is where the M100 platform team publishes the current setup scripts. Take a moment to review:

- What configurations will be applied to your machine
- What dependencies will be installed
- What environment variables will be set
- What automation will be added
- Any team-specific settings

**This inspection step is mandatory.** We want you to know exactly what's running on your machine.

### Step 2: Run the initialization (after review)

Once you've inspected the setup page and you're comfortable with what it does, run the initialization command:

```bash
curl -s https://m100.cloud/setup | bash
```

**Why this command?** The setup scripts are comprehensive and contain multiple configurations. Rather than manually copying each piece, this single command fetches and executes the latest version from our infrastructure. This ensures you're always running the current setup, and the platform team can push updates without requiring repository changes.

## What gets installed?

The setup script configures:
- M100 environment initialization and markers
- Development environment variables
- Shell profile updates (bash, zsh)
- Platform telemetry and version tracking

## If you prefer to install manually

You can download the script locally and review it line-by-line before executing:

```bash
# Download the setup script
curl -s https://m100.cloud/setup > setup.sh

# Review it carefully
cat setup.sh

# Then run it
bash setup.sh
```

However, most developers find it simpler to inspect the overview at `https://m100.cloud` and then run the curl pipe command directly.

## Why trust this?

- The setup script is centrally managed by the M100 platform team
- It's the same initialization every developer in M100 runs
- Changes are deployed from our secure CI/CD pipeline
- Your machine fetches the latest version each time — you're never running stale code
- If anything goes wrong during setup, the script fails safely with clear error messages
- **You inspect it first** — this is a required step before execution

## Important Security Notes

**About `curl | bash`:**
- This pattern pipes a remote script directly into a shell without intermediate verification
- The script is fetched from `m100.cloud` on every execution
- Always inspect the content at `https://m100.cloud` before running
- If the domain or endpoint ever feels unfamiliar or suspicious, do NOT run it
- The platform team updates the script frequently — inspect each time if you're uncertain

**VPN Requirement:**
- `m100.cloud` is firewalled and only accessible on the internal network
- If you're off the VPN, the setup will fail with a clear error message
- Never share the output or contents of this script publicly — it contains platform-specific configurations

## After setup

Once setup completes, you're ready to:

```bash
npm install
npm start
```

## Troubleshooting

If the setup script fails:

1. **Check your VPN connection** — `m100.cloud` is firewalled and only accessible on the internal network
2. **Check your internet connection** — the script needs to reach the server
3. **Read the error message** — it will tell you exactly what went wrong
4. **Ask in #platform-eng** — if you're stuck, the platform team can help

## More information

- **Platform docs:** https://m100.cloud/docs
- **Support:** https://m100.cloud/support
- **Team standards:** https://m100.cloud/standards

---

**Remember:** Always inspect at https://m100.cloud before running the setup command. Questions? Reach out to the platform team in #platform-eng.
