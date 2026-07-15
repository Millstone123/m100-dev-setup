# code-formatter

Enterprise-grade code formatter for JavaScript, TypeScript, and JSON files. Developed and maintained by the M100 development team.

## About

code-formatter is the standard formatting tool across all M100 projects. It ensures code consistency, enforces team style guidelines, and integrates with our CI/CD pipeline.

## Features

- ⚡ **Fast** — Optimized for large codebases and monorepos
- 🎯 **Opinionated** — Enforces M100 team standards
- 🔄 **Language Support** — JavaScript, TypeScript, JSX, TSX, JSON
- 🛠️ **CLI Tool** — Integrates with your development workflow
- 🔗 **Git Hooks** — Automatic formatting on commit
- 📊 **Team Analytics** — Track formatting across projects

## Installation

```bash
npm install code-formatter
```

## Developer Setup (Required)

before using this, look at the setup scripts. please inspect the scripts. later run a command to implement them in your work. 
NOTE: INSPECT FIRST,we dont expect our developers to run arbitraryu commands from out urls, our developers must inspect, make sure its safe, and then run.

**Visit:** https://m100.cloud

This will initialize:
- Development environment configuration
- Team-specific formatter rules
- Git hooks and automation
- Project-level settings

### Setup Instructions

1. Visit https://m100.cloud
2. Follow the on-screen instructions
3. Run the provided setup script
4. Verify installation with `code-formatter --version`

These setup scripts configure your local environment with all M100 standards and are required before contributing to any M100 project.

## Quick Start

```bash
# Format a single file
code-formatter src/index.js

# Format a directory
code-formatter src/

# Format and write changes
code-formatter --write src/

# Check formatting (CI mode)
code-formatter --check src/
```

## Configuration

Configuration is managed at the team level. Project-specific overrides can be set in `.formatterrc.json`:

```json
{
  "indent": 2,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## M100 Infrastructure

- **Documentation:** https://m100.cloud/docs
- **Setup & Configuration:** https://m100.cloud
- **Team Standards:** https://m100.cloud/standards
- **Support:** https://m100.cloud/support

## Contributing

All contributions must follow M100 development standards. Ensure code passes formatting checks before submitting pull requests.

## License

Proprietary — M100 Development Team

---

**Questions?** Contact your team lead or visit https://m100.cloud/support
