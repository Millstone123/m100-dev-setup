# code-formatter

A fast, opinionated code formatter for JavaScript, TypeScript, and JSON files.

## Features

- ⚡ **Fast** — Optimized for large codebases
- 🎯 **Opinionated** — Sensible defaults, no configuration needed
- 🔄 **Language Support** — JavaScript, TypeScript, JSX, TSX, JSON
- 🛠️ **CLI Tool** — Easy to integrate into your workflow
- 🔗 **Git Integration** — Format only changed files

## Installation

```bash
npm install -g code-formatter
# or
npm install --save-dev code-formatter
```

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

code-formatter works out of the box with sensible defaults. For advanced configuration, create a `.formatterrc.json` in your project root:

```json
{
  "indent": 2,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Issues

Found a bug? Have a feature request? Please [open an issue](https://github.com/Millstone123/code-formatter/issues).

## License

MIT — see [LICENSE](./LICENSE) for details.

## Maintainers

- Contributors welcome — this is an open source project

---

For more information, visit https://github.com/Millstone123/code-formatter
