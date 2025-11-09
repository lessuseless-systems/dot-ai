# AI Tool Configuration File Matrix

**Purpose:** Comprehensive catalog of AI developer tools and their configuration files/dotfiles for building the `.ai` abstraction layer.

**Last Updated:** 2025-11-07 (Added 18 tools from nix-ai-tools repository)

---

## Table of Contents
1. [IDEs & Editors](#1-ides--editors)
2. [CLI Tools](#2-cli-tools)
3. [Desktop Applications](#3-desktop-applications)
4. [Cloud/Platform Services](#4-cloudplatform-services)
5. [Tool Marketplaces & Installers](#5-tool-marketplaces--installers)
6. [Summary Statistics](#6-summary-statistics)

---

## 1. IDEs & Editors

### VS Code
| Property | Value |
|----------|-------|
| **Tool Type** | IDE/Editor |
| **MCP Support** | Yes (via `.vscode/mcp.json`) |
| **Global Config Path (Linux)** | `$HOME/.config/Code/User/settings.json` |
| **Global Config Path (macOS)** | `~/Library/Application Support/Code/User/settings.json` |
| **Global Config Path (Windows)** | `%APPDATA%\Code\User\settings.json` |
| **Project Dotfile** | `.vscode/` |
| **Project Config Files** | `settings.json`, `mcp.json` (proposed) |
| **Config Format** | JSON |
| **Config Scope** | Editor/Workspace settings, MCP servers, language tooling |
| **Key Features** | Language settings, formatter config, tasks, extensions |
| **XDG Compliant** | Partial (Linux only) |
| **Source** | Research Doc §III.A |

### Zed Editor
| Property | Value |
|----------|-------|
| **Tool Type** | IDE/Editor |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `$XDG_CONFIG_HOME/zed/settings.json` (default: `~/.config/zed/`) |
| **Global Config Path (macOS)** | `~/.zed/settings.json` |
| **Global Config Path (Windows)** | Not specified |
| **Project Dotfile** | `.zed/` |
| **Project Config Files** | `settings.json` |
| **Config Format** | JSON (superset) |
| **Config Scope** | Editor/Tooling behavior (non-cosmetic only) |
| **Key Features** | `tab_size`, `formatter`, language tooling (excludes themes/vim_mode at project level) |
| **XDG Compliant** | Yes (Linux) |
| **Philosophy** | Only version-controllable, team-relevant settings at project level |
| **Source** | Research Doc §III.A, Table 1 |

### Cursor IDE
| Property | Value |
|----------|-------|
| **Tool Type** | IDE/Editor (VS Code fork) |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `~/.cursor/mcp.json` |
| **Global Config Path (macOS)** | `~/.cursor/mcp.json` |
| **Global Config Path (Windows)** | `%USERPROFILE%\.cursor\mcp.json` |
| **Project Dotfile** | `.cursor/` |
| **Project Config Files** | `mcp.json`, `cli.json` |
| **Config Format** | JSON |
| **Config Scope** | MCP server definitions (IDE), permissions (CLI) |
| **Key Features** | Separates MCP servers from permissions across IDE/CLI |
| **Unique Behavior** | Cursor CLI restricts project config to permissions only |
| **Source** | Research Doc §II.B, §III.B, Table 2 |

### JetBrains IDEs (Junie)
| Property | Value |
|----------|-------|
| **Tool Type** | IDE (IntelliJ, PyCharm, etc.) |
| **MCP Support** | Yes (via Junie AI assistant) |
| **Global Config Path** | Not documented |
| **Project Dotfile** | `.junie/mcp/` |
| **Project Config Files** | `mcp.json` |
| **Config Format** | JSON |
| **Config Scope** | MCP server definitions |
| **Key Features** | Deeper subdirectory structure |
| **Source** | Research Doc §II.B, Table 2 |

### Visual Studio (Windows)
| Property | Value |
|----------|-------|
| **Tool Type** | IDE |
| **MCP Support** | Yes |
| **Global Config Path** | Not specified |
| **Project Dotfile** | `.vscode/` (shared with VS Code) |
| **Project Config Files** | `mcp.json`, `.mcp.json` (root) |
| **Config Format** | JSON |
| **Config Scope** | MCP server definitions |
| **Key Features** | Supports both `.vscode/mcp.json` and `.mcp.json` at project root |
| **Emerging Standard** | Recognizes `.mcp.json` at root as tool-agnostic format |
| **Source** | Research Doc §II.B |

### Windsurf IDE
| Property | Value |
|----------|-------|
| **Tool Type** | IDE |
| **MCP Support** | Yes (Cascade integration) |
| **Global Config Path (Linux)** | `~/.codeium/windsurf/mcp_config.json` |
| **Global Config Path (macOS)** | `~/.codeium/windsurf/mcp_config.json` |
| **Global Config Path (Windows)** | `%USERPROFILE%\.codeium\windsurf\mcp_config.json` |
| **Project Dotfile** | Not specified |
| **Project Config Files** | Not specified |
| **Config Format** | JSON |
| **Config Scope** | MCP configuration |
| **Source** | Research Doc §I.A |

### OpenCode
| Property | Value |
|----------|-------|
| **Tool Type** | IDE/Editor |
| **MCP Support** | Unknown |
| **Global Config Path (Linux)** | `~/.config/opencode/opencode.json` |
| **Global Config Path (macOS)** | `~/.config/opencode/opencode.json` |
| **Global Config Path (Windows)** | Not specified |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | JSON |
| **XDG Compliant** | Yes |
| **Source** | Research Doc §I.C, Table 1 |

---

## 2. CLI Tools

### Aider
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | `.aider/` (assumed) |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | Not in nix-ai-tools (needs research) |
| **Status** | Mentioned in PLANNING.md, needs research |

### Backlog.md
| Property | Value |
|----------|-------|
| **Tool Type** | CLI (Project Management/Collaboration) |
| **Description** | "Tool for managing project collaboration between humans and AI Agents in a git ecosystem" |
| **Version** | 1.18.5 |
| **License** | MIT |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown (likely backlog.md file) |
| **Config Format** | Markdown (assumed) |
| **Nix Package** | `github:numtide/nix-ai-tools#backlog-md` |
| **Status** | Needs configuration research |

### Catnip
| Property | Value |
|----------|-------|
| **Tool Type** | CLI (Development Environment) |
| **Description** | "Developer environment that's like catnip for agentic programming" |
| **Version** | 0.11.2 |
| **License** | Apache-2.0 |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#catnip` |
| **Status** | Needs configuration research |

### Claude Code
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "Agentic coding tool that lives in your terminal, understands your codebase, helps you code faster" |
| **Version** | 2.0.35 |
| **License** | unfree |
| **MCP Support** | Yes (likely via Claude Desktop config) |
| **Global Config Path** | Likely shares with Claude Desktop |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#claude-code` |
| **Status** | Needs configuration research |

### Claude Code ACP
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent (ACP-compatible) |
| **Description** | "ACP-compatible coding agent powered by the Claude Code SDK (TypeScript)" |
| **Version** | 0.10.0 |
| **License** | Apache-2.0 |
| **MCP Support** | Yes (ACP protocol) |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#claude-code-acp` |
| **Documentation** | packages/claude-code-acp/README.md |
| **Status** | Needs configuration research |

### Claude Code Router
| Property | Value |
|----------|-------|
| **Tool Type** | CLI (Proxy/Router) |
| **Description** | "Use Claude Code without an Anthropics account and route it to another LLM provider" |
| **Version** | 1.0.65 |
| **License** | MIT |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#claude-code-router` |
| **Status** | Needs configuration research |

### Claudebox
| Property | Value |
|----------|-------|
| **Tool Type** | Sandbox Environment |
| **Description** | "Sandboxed environment for Claude Code" |
| **License** | Check package |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#claudebox` |
| **Documentation** | packages/claudebox/README.md |
| **Status** | Needs configuration research |

### Code (fork of Codex)
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "Fork of codex. Orchestrate agents from OpenAI, Claude, Gemini or any provider" |
| **Version** | 0.4.9 |
| **License** | Apache-2.0 |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown (likely similar to Codex) |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown (Codex uses TOML) |
| **Nix Package** | `github:numtide/nix-ai-tools#code` |
| **Status** | Needs configuration research |

### CodeRabbit CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI (Code Review) |
| **Description** | "AI-powered code review CLI tool" |
| **Version** | 0.3.4 |
| **License** | unfree |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#coderabbit-cli` |
| **Status** | Needs configuration research |

### Codex (OpenAI)
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "OpenAI Codex CLI - a coding agent that runs locally on your computer" |
| **Version** | 0.55.0 |
| **License** | Apache-2.0 |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `~/.codex/config.toml` |
| **Global Config Path (macOS)** | `~/.codex/config.toml` |
| **Global Config Path (Windows)** | `%USERPROFILE%\.codex\config.toml` |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | **TOML** (unique) |
| **Config Scope** | MCP servers, model overrides |
| **Special Requirements** | TOML parser needed for translation |
| **Nix Package** | `github:numtide/nix-ai-tools#codex` |
| **Source** | Research Doc §V.A, Table 3 |

### Codex ACP
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent (ACP-compatible) |
| **Description** | "ACP-compatible coding agent powered by Codex" |
| **Version** | 0.3.13 |
| **License** | Apache-2.0 |
| **MCP Support** | Yes (ACP protocol) |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#codex-acp` |
| **Documentation** | packages/codex-acp/README.md |
| **Status** | Needs configuration research |

### Cursor Agent
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "CLI tool for Cursor AI code editor" |
| **Version** | 2025.11.06-8fe8a63 |
| **License** | unfree |
| **MCP Support** | Likely (related to Cursor IDE) |
| **Global Config Path** | Unknown (possibly shares with Cursor IDE) |
| **Project Dotfile** | Unknown (possibly `.cursor/`) |
| **Project Config Files** | Unknown |
| **Config Format** | JSON (assumed) |
| **Nix Package** | `github:numtide/nix-ai-tools#cursor-agent` |
| **Note** | Separate from Cursor IDE and Cursor CLI |
| **Status** | Needs configuration research |

### Droid (Factory AI)
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "Factory AI's Droid - AI-powered development agent for your terminal" |
| **Version** | 0.22.12 |
| **License** | unfree |
| **MCP Support** | Yes (Factory supports MCP) |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | JSON (assumed, Factory uses JSON) |
| **Nix Package** | `github:numtide/nix-ai-tools#droid` |
| **Related** | Factory CLI (mentioned in research) |
| **Status** | Needs configuration research |

### ECA (Editor Code Assistant)
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "AI pair programming capabilities agnostic of editor" |
| **Version** | 0.77.1 |
| **License** | Apache-2.0 |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#eca` |
| **Status** | Needs configuration research |

### Forge
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent (Development Environment) |
| **Description** | "AI-Enhanced Terminal Development Environment - comprehensive coding agent integrating AI with dev environment" |
| **Version** | 1.3.0 |
| **License** | MIT |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#forge` |
| **Documentation** | packages/forge/README.md |
| **Status** | Needs configuration research |

### Gemini CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `~/.gemini/settings.json` |
| **Global Config Path (macOS)** | `~/.gemini/settings.json` |
| **Global Config Path (Windows)** | `%USERPROFILE%\.gemini\settings.json` |
| **Project Dotfile** | `.gemini/` |
| **Project Config Files** | `settings.json`, `GEMINI.md` (context reference) |
| **Config Format** | JSON + Markdown |
| **Config Scope** | General settings, model overrides, context file references |
| **Key Features** | References custom context files like `GEMINI.md` |
| **Precedence** | Project > User > CLI Defaults (explicit hierarchy) |
| **Merging Strategy** | Override (not merge) |
| **Source** | Research Doc §I.A, §I.B, §III.B, Table 2 |

### Amp CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Yes |
| **Global Config Path** | Not specified |
| **Project Dotfile** | `.amp/` |
| **Project Config Files** | `settings.json` |
| **Config Format** | JSON (monolithic) |
| **Config Scope** | Agent capabilities, security, MCP servers |
| **Key Features** | `amp.mcpServers`, `amp.permissions`, `amp.tools.disable` |
| **Merging Strategy** | Explicit merge with global settings |
| **Unique Behavior** | Comprehensive single-file approach with nested objects |
| **Source** | Research Doc §I.B, §III.B, Table 2 |

### Crush CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `$HOME/.config/crush/crush.json` |
| **Global Config Path (macOS)** | `$HOME/.config/crush/crush.json` |
| **Global Config Path (Windows)** | `%USERPROFILE%\AppData\Local\crush\crush.json` |
| **Project Dotfile** | `.crush.json` (dotfile) OR `crush.json` (non-dotfile) |
| **Project Config Files** | `crush.json` OR `.crush.json` |
| **Config Format** | JSON |
| **Merging Strategy** | Strict priority hierarchy (no merge, full override) |
| **Precedence** | `.crush.json` > `crush.json` > Global XDG |
| **XDG Compliant** | Yes |
| **Source** | Research Doc §I.B, Table 1 |

### GitHub Copilot CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `~/.copilot/mcp-config.json` |
| **Global Config Path (macOS)** | `~/.copilot/mcp-config.json` |
| **Global Config Path (Windows)** | Not specified |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | JSON |
| **Config Scope** | MCP server configuration |
| **Known Issues** | MCP servers configured but tools not exposed (GitHub issue #191) |
| **Source** | Research Doc Table 1 |

### Amazon Q Developer CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Yes (custom agents) |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Configuration for custom agents |
| **Config Format** | JSON |
| **Config Scope** | Permissions/access control |
| **Key Features** | `execute_bash` whitelists, `fs_read` path controls |
| **Security Model** | Explicit allow/deny lists for tool access |
| **Source** | Research Doc §IV.B, Table 3 |

### Cursor CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI (companion to Cursor IDE) |
| **MCP Support** | Limited (permissions only) |
| **Global Config Path** | Same as Cursor IDE |
| **Project Dotfile** | `.cursor/` |
| **Project Config Files** | `cli.json` |
| **Config Format** | JSON |
| **Config Scope** | Permissions/access control ONLY |
| **Unique Behavior** | Deliberately separates concerns (no MCP server defs at project level) |
| **Source** | Research Doc §II.B, Table 2 |

### Aider
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | `.aider/` (assumed) |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Status** | Mentioned in PLANNING.md, needs research |

### Factory CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **MCP Support** | Yes |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | MCP configuration |
| **Config Format** | JSON |
| **Transport Support** | STDIO and HTTP |
| **Source** | Research Doc citations |
| **Related** | Droid (Factory AI's CLI agent in nix-ai-tools) |

### Goose CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "CLI for Goose - a local, extensible, open source AI agent that automates engineering tasks" |
| **Version** | 1.13.0 |
| **License** | Apache-2.0 |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#goose-cli` |
| **Status** | Needs configuration research |

### Groq Code CLI
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "Highly customizable, lightweight, open-source coding CLI powered by Groq for instant iteration" |
| **Version** | 1.0.2-unstable-2025-09-05 |
| **License** | MIT |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#groq-code-cli` |
| **Status** | Needs configuration research |

### Nanocoder
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "Beautiful local-first coding agent running in your terminal - built by community for community" |
| **Version** | 1.15.0 |
| **License** | MIT |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#nanocoder` |
| **Status** | Needs configuration research |

### Qwen Code
| Property | Value |
|----------|-------|
| **Tool Type** | CLI Agent |
| **Description** | "Command-line AI workflow tool for Qwen3-Coder models" |
| **Version** | 0.1.4 |
| **License** | Apache-2.0 |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown (possibly QWEN.md for context) |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#qwen-code` |
| **Agent Instruction File** | `QWEN.md` (mentioned in PLANNING.md) |
| **Status** | Needs configuration research |

### Spec Kit
| Property | Value |
|----------|-------|
| **Tool Type** | CLI (Spec-Driven Development) |
| **Description** | "Specify CLI, part of GitHub Spec Kit. Tool to bootstrap projects for Spec-Driven Development (SDD)" |
| **Version** | 0.0.79 |
| **License** | MIT |
| **MCP Support** | Unknown |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Nix Package** | `github:numtide/nix-ai-tools#spec-kit` |
| **Status** | Needs configuration research |

---

## 3. Desktop Applications

### Claude Desktop / Claude Code
| Property | Value |
|----------|-------|
| **Tool Type** | Desktop App / CLI |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `~/.config/Claude/claude_desktop_config.json` (assumed) |
| **Global Config Path (macOS)** | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| **Global Config Path (Windows)** | `%APPDATA%\Claude\claude_desktop_config.json` |
| **Project Dotfile** | Unknown (possibly none) |
| **Project Config Files** | Unknown |
| **Config Format** | JSON |
| **Config Scope** | MCP server definitions |
| **Platform Behavior** | Uses Application Support directories |
| **Source** | Research Doc §I.C |

### LM Studio
| Property | Value |
|----------|-------|
| **Tool Type** | Desktop App (local LLM runner) |
| **MCP Support** | Yes (as of v0.3.17) |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Source** | Research Doc citations |

### Dot (GetDot.ai)
| Property | Value |
|----------|-------|
| **Tool Type** | Desktop App / Browser Extension |
| **MCP Support** | Yes |
| **Global Config Path** | Unknown |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | Unknown |
| **Source** | Research Doc citations |

---

## 4. Cloud/Platform Services

### OpenAI Codex
| Property | Value |
|----------|-------|
| **Tool Type** | Cloud Service / CLI |
| **MCP Support** | Yes |
| **Global Config Path (Linux)** | `~/.codex/config.toml` |
| **Global Config Path (macOS)** | `~/.codex/config.toml` |
| **Global Config Path (Windows)** | `%USERPROFILE%\.codex\config.toml` |
| **Project Dotfile** | Unknown |
| **Project Config Files** | Unknown |
| **Config Format** | **TOML** (unique) |
| **Config Scope** | MCP servers, model overrides |
| **Special Requirements** | TOML parser needed for translation |
| **Source** | Research Doc §V.A, Table 3 |

---

## 5. Tool Marketplaces & Installers

### Smithery
| Property | Value |
|----------|-------|
| **Tool Type** | MCP Marketplace / Installer |
| **MCP Support** | Yes (marketplace) |
| **Global Config Path** | N/A |
| **Project Dotfile** | None (uses root config) |
| **Project Config Files** | `smithery.yaml` (project root) |
| **Config Format** | **YAML** |
| **Config Scope** | MCP server configuration |
| **Unique Behavior** | Uses project root (not dotfile) |
| **Special Requirements** | YAML parser needed |
| **Source** | Research Doc §II.B, §V.A |

---

## 6. Summary Statistics

### Tools by Type
| Category | Count | Tools |
|----------|-------|-------|
| **IDEs/Editors** | 7 | VS Code, Zed, Cursor IDE, JetBrains, Visual Studio, Windsurf, OpenCode |
| **CLI Tools** | 32 | Aider, Amp, Backlog.md, Catnip, Claude Code, Claude Code ACP, Claude Code Router, Claudebox, Code, CodeRabbit CLI, Codex, Codex ACP, Copilot CLI, Crush, Cursor Agent, Cursor CLI, Droid, ECA, Factory, Forge, Gemini CLI, Goose CLI, Groq Code CLI, Amazon Q, Nanocoder, OpenCode CLI, Qwen Code, Spec Kit |
| **Desktop Apps** | 3 | Claude Desktop, LM Studio, Dot |
| **Cloud Services** | 1 | OpenAI Codex (also has CLI) |
| **Marketplaces** | 1 | Smithery |
| **TOTAL** | 44 | |

### Tools from nix-ai-tools
**Total in nix-ai-tools:** 25 tools
- Amp, Backlog.md, Catnip, Claude Code, Claude Code ACP, Claude Code Router, Claudebox, Code, CodeRabbit CLI, Codex, Codex ACP, Copilot CLI, Crush, Cursor Agent, Droid, ECA, Forge, Gemini CLI, Goose CLI, Groq Code CLI, Nanocoder, OpenCode, Qwen Code, Spec Kit, Claude Desktop

**Available via Nix:** All tools listed above can be installed via `nix run github:numtide/nix-ai-tools#<tool-name>`

### Config Format Distribution
| Format | Count | Tools |
|--------|-------|-------|
| **JSON** | 17 | VS Code, Zed, Cursor, JetBrains, Visual Studio, Windsurf, OpenCode, Gemini CLI, Amp, Crush, Copilot CLI, Amazon Q, Claude Desktop, LM Studio, Dot, Factory, Cursor CLI |
| **TOML** | 1 | OpenAI Codex |
| **YAML** | 1 | Smithery |
| **Markdown** | 1+ | Gemini CLI (context files), General pattern (CLAUDE.md, GEMINI.md) |

### XDG Compliance
| Compliance Level | Count | Tools |
|------------------|-------|-------|
| **XDG Compliant** | 3 | Zed (Linux), Crush, OpenCode |
| **Partial** | 1 | VS Code (Linux only) |
| **Proprietary Paths** | 14 | Gemini CLI, Cursor, Copilot CLI, Claude Desktop, Windsurf, etc. |
| **Unknown** | 2 | Aider, Continue |

### Project Dotfile Patterns
| Pattern | Count | Examples |
|---------|-------|----------|
| **Dedicated dotfolder** | 9 | `.vscode/`, `.cursor/`, `.amp/`, `.gemini/`, `.zed/`, `.junie/mcp/` |
| **Dotfile at root** | 1 | `.crush.json` |
| **Non-dotfile at root** | 2 | `smithery.yaml`, `.mcp.json` |
| **No project config** | 3 | Claude Desktop, LM Studio, Windsurf (global only) |
| **Unknown** | 5 | Aider, Continue, OpenCode, Factory, Dot |

### MCP Configuration Separation
| Behavior | Count | Tools |
|----------|-------|-------|
| **MCP + Permissions Combined** | 1 | Amp CLI (`settings.json`) |
| **MCP Separate, Permissions Separate** | 2 | Cursor (IDE: `mcp.json`, CLI: `cli.json`) |
| **MCP Only** | 14+ | Most tools (permissions not explicitly documented) |
| **Unknown** | 3 | Aider, Continue, OpenCode |

---

## 7. Canonical File Mapping

### Global Configuration Locations (by Platform)

#### Linux
```
~/.config/Code/User/settings.json         # VS Code
~/.config/zed/settings.json               # Zed
~/.config/crush/crush.json                # Crush CLI
~/.config/opencode/opencode.json          # OpenCode
~/.gemini/settings.json                   # Gemini CLI
~/.cursor/mcp.json                        # Cursor IDE
~/.copilot/mcp-config.json               # Copilot CLI
~/.codeium/windsurf/mcp_config.json      # Windsurf
~/.codex/config.toml                      # OpenAI Codex
```

#### macOS
```
~/Library/Application Support/Code/User/settings.json   # VS Code
~/Library/Application Support/Claude/claude_desktop_config.json  # Claude Desktop
~/.zed/settings.json                      # Zed
~/.config/crush/crush.json                # Crush CLI
~/.gemini/settings.json                   # Gemini CLI
~/.cursor/mcp.json                        # Cursor IDE
~/.copilot/mcp-config.json               # Copilot CLI
~/.codeium/windsurf/mcp_config.json      # Windsurf
~/.codex/config.toml                      # OpenAI Codex
```

#### Windows
```
%APPDATA%\Code\User\settings.json         # VS Code
%APPDATA%\Claude\claude_desktop_config.json  # Claude Desktop
%USERPROFILE%\.gemini\settings.json       # Gemini CLI
%USERPROFILE%\.cursor\mcp.json            # Cursor IDE
%USERPROFILE%\AppData\Local\crush\crush.json  # Crush CLI
%USERPROFILE%\.codeium\windsurf\mcp_config.json  # Windsurf
%USERPROFILE%\.codex\config.toml          # OpenAI Codex
```

### Project-Level Configuration Locations

```
# Dedicated dotfolders
.vscode/settings.json, .vscode/mcp.json   # VS Code, Visual Studio
.cursor/mcp.json                          # Cursor IDE (MCP)
.cursor/cli.json                          # Cursor CLI (permissions)
.amp/settings.json                        # Amp CLI
.gemini/settings.json                     # Gemini CLI
.zed/settings.json                        # Zed Editor
.junie/mcp/mcp.json                       # JetBrains/Junie

# Root-level files
.crush.json                               # Crush CLI (dotfile)
crush.json                                # Crush CLI (non-dotfile)
.mcp.json                                 # Emerging standard (VS)
smithery.yaml                             # Smithery

# Markdown context files (convention)
CLAUDE.md                                 # Claude-specific
GEMINI.md                                 # Gemini-specific
AGENTS.md                                 # General agent instructions
QWEN.md                                   # Qwen-specific
```

---

## 8. Research Gaps & Unknown Configuration

### Tools Requiring Additional Research

**Priority 1 (Available in nix-ai-tools):**
- [ ] Claude Code - Config locations, MCP integration pattern
- [ ] Cursor Agent - Relationship to Cursor IDE/CLI configs
- [ ] Goose CLI - Config structure, MCP support
- [ ] Forge - Development environment config
- [ ] Nanocoder - Local-first config approach
- [ ] Groq Code CLI - Groq-specific config
- [ ] Qwen Code - Qwen model config, QWEN.md pattern
- [ ] Catnip - Development environment specifics
- [ ] ECA - Editor-agnostic config approach
- [ ] Droid/Factory - Factory AI config patterns
- [ ] CodeRabbit CLI - Code review integration
- [ ] Backlog.md - Git-based collaboration config
- [ ] Spec Kit - Spec-driven development config
- [ ] Claude Code ACP, Codex ACP - ACP protocol configs
- [ ] Code (Codex fork) - Multi-provider orchestration
- [ ] Claude Code Router - Provider routing config
- [ ] Claudebox - Sandbox environment setup

**Priority 2 (Not in nix-ai-tools):**
- [ ] Aider - Global config location, dotfile structure
- [ ] Continue - All configuration details, MCP support

#### LM Studio
- [ ] Global config path
- [ ] Project-level config support
- [ ] Config file format/structure

#### Dot (GetDot.ai)
- [ ] Configuration locations
- [ ] Config format
- [ ] Project-level support

#### Factory CLI
- [ ] Config file locations
- [ ] Detailed structure

#### Windsurf
- [ ] Project-level config (if any)
- [ ] Config file structure details

#### Amazon Q Developer
- [ ] Global config location
- [ ] Project dotfile structure
- [ ] Complete permissions schema

#### OpenCode
- [ ] Project dotfile patterns
- [ ] MCP support status
- [ ] Config structure

---

## 9. Configuration Content Categories

What each tool stores (for `.ai` abstraction mapping):

### MCP Server Definitions
**Stored by:** VS Code, Cursor IDE, Gemini CLI, Amp CLI, Crush CLI, Copilot CLI, JetBrains, Visual Studio, Windsurf, Claude Desktop, OpenAI Codex, Smithery, Factory

**Structure (STDIO):**
```json
{
  "server-name": {
    "command": "executable",
    "args": ["arg1", "arg2"],
    "env": {
      "API_KEY": "value"
    }
  }
}
```

**Structure (HTTP):**
```json
{
  "server-name": {
    "url": "https://api.example.com/mcp",
    "headers": {
      "Authorization": "Bearer token"
    }
  }
}
```

### Permissions/Security
**Stored by:** Amp CLI, Cursor CLI, Amazon Q Developer

**Examples:**
- `execute_bash`: whitelist/denylist of shell commands
- `fs_read`: allowed read paths
- `fs_write`: allowed write paths
- `network`: network access rules

### Editor/Language Settings
**Stored by:** VS Code, Zed, Visual Studio

**Examples:**
- `tab_size`, `indent_style`
- `formatter` configuration
- Language server settings
- Linting rules

### Model Configuration
**Stored by:** Gemini CLI, OpenAI Codex

**Examples:**
- Default model selection
- API endpoints
- Model-specific parameters

### Context References
**Stored by:** Gemini CLI (explicit), others (implicit via .md files)

**Examples:**
- References to `GEMINI.md`, `CLAUDE.md`
- Project architecture documentation
- Custom instruction files

---

## 10. Translation Priorities (for lib-ai)

Based on tool popularity, documentation quality, and configuration complexity:

### Tier 1 (Immediate Priority)
1. **Cursor IDE** - Most documented, clear MCP + permissions separation
2. **VS Code** - Most popular, extensive ecosystem
3. **Gemini CLI** - Well-documented precedence model, context file pattern
4. **Claude Desktop** - Primary Anthropic tool

### Tier 2 (High Priority)
5. **Amp CLI** - Comprehensive single-file approach, good merging example
6. **Zed Editor** - Modern, clean project-level philosophy
7. **Amazon Q Developer** - Robust permissions model

### Tier 3 (Medium Priority)
8. **Crush CLI** - Clean priority hierarchy, XDG compliant
9. **JetBrains/Junie** - Large IDE ecosystem
10. **Visual Studio** - Microsoft ecosystem

### Tier 4 (Future)
11. OpenAI Codex (TOML support needed)
12. Smithery (YAML support needed)
13. Windsurf, LM Studio, Dot, Factory
14. Aider, Continue (research needed)

---

## 11. Key Insights for `.ai` Design

### Validated Patterns
1. **Two-tier scope** (global + project) is universal
2. **Project configs version-controlled**, global configs are not
3. **MCP server definitions** are structurally consistent across tools
4. **Permissions/security** emerging as separate concern
5. **Markdown context files** convention exists (`GEMINI.md`, `CLAUDE.md`)

### Validated Needs
1. **`mcp_servers.json`** - Universal need, consistent structure
2. **`permissions.json`** - Explicit in Amp/Cursor/Amazon Q, implicit elsewhere
3. **`agent_context.md`** - Gemini CLI pattern, general .md file convention
4. **`model_config.json`** - Gemini CLI, Codex demonstrate need
5. **`editor_prefs.json`** - VS Code, Zed show importance for AI code generation

### Design Challenges
1. **Path resolution** across 3 OS types and XDG vs proprietary
2. **Format translation** (JSON primary, TOML/YAML secondary)
3. **Object merging** vs strict override (tool-dependent)
4. **Nested vs flat** config structures (Amp uses nesting)
5. **Separation of concerns** (Cursor splits MCP/permissions across files)

---

## 12. References

All information extracted from:
- `/home/lessuseless/Downloads/AI Tool Dotfile Configuration Research.md`
- `PLANNING.md` (this project)
- `https://github.com/lessuselesss/nix-ai-tools` - Nix packages for AI tools (25 tools)

**Next Steps:**
- Research configurations for nix-ai-tools packages (Priority 1 in §8)
- Fill remaining research gaps (§8)
- Prototype translation for Tier 1 tools (§10)
- Define Nickel schemas based on common patterns (§9)
- Leverage nix-ai-tools for testing and validation

---

**Document Status:** v1.0 - Comprehensive Catalog
**Contributors:** Research synthesis from AI Tool Dotfile Configuration Research
**Maintenance:** Update as new tools emerge or configurations change
