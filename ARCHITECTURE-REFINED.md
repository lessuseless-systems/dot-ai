# lib-ai Refined Architecture

**Date:** 2025-11-07
**Status:** Design refinement based on research findings

---

## Core Principles

1. **Centralized under `.ai/`** - All AI tool configs live in one place
2. **Clean project root** - No proliferation of dotfiles (`.cursor/`, `.gemini/`, etc.)
3. **Single source of truth** - Define settings ONCE in canonical format
4. **Transformers** - Translate `.ai/` configs to tool-specific formats
5. **Like dotfiles managers** - Similar to GNU Stow, chezmoi, home-manager

---

## The Problem We're Solving

### Current State (Fragmented)
```
project-root/
├── .cursor/
│   ├── mcp.json
│   └── cli.json
├── .gemini/
│   └── settings.json
├── .amp/
│   └── settings.json
├── .cursorrules
├── CLAUDE.md
├── GEMINI.md
├── AGENTS.md
├── .vscode/
│   └── settings.json
└── (your actual project files)
```

**Problems:**
- 🔴 Root directory cluttered with 7+ dotfiles/folders
- 🔴 Same settings duplicated across tools
- 🔴 Update one tool → must update others manually
- 🔴 Hard to version control (some ignored, some not)
- 🔴 Tool-specific formats (JSON, TOML, YAML, Markdown)

### Proposed State (Unified)
```
project-root/
├── .ai/                      # ✅ Single directory for ALL AI tooling
│   ├── config.ncl            # Canonical configuration
│   ├── AGENTS.md             # Universal instruction file
│   │
│   ├── cursor/               # Tool-specific (generated)
│   │   ├── mcp.json
│   │   └── cli.json
│   ├── gemini/               # Tool-specific (generated)
│   │   └── settings.json
│   ├── claude/               # Tool-specific (generated)
│   │   └── CLAUDE.md
│   └── vscode/               # Tool-specific (generated)
│       └── settings.json
│
└── (your actual project files - clean!)
```

**Benefits:**
- ✅ Root directory clean
- ✅ Settings defined once in `config.ncl`
- ✅ Transformers generate tool-specific files
- ✅ Easy to version control (everything under `.ai/`)
- ✅ Add new tool → just add transformer

---

## Architecture Overview

### 1. Canonical Configuration (`.ai/config.ncl`)

**Single source of truth** in Nickel format:

```nickel
{
  # MCP Servers (universal)
  mcp_servers = {
    filesystem = {
      command = "npx",
      args = ["-y", "@modelcontextprotocol/server-filesystem", "/path"],
      env = {}
    },
    github = {
      command = "npx",
      args = ["-y", "@modelcontextprotocol/server-github"],
      env = { GITHUB_TOKEN = "${GITHUB_TOKEN}" }
    }
  },

  # Permissions (universal)
  permissions = {
    execute_bash = ["git", "npm", "make"],
    fs_read = ["/project"],
    fs_write = ["/project/src"]
  },

  # Model preferences (universal)
  model_config = {
    default_model = "claude-sonnet-4",
    temperature = 0.7
  },

  # Editor preferences (universal)
  editor_prefs = {
    tab_size = 2,
    use_spaces = true,
    formatter = "prettier"
  },

  # Tool-specific overrides
  tool_overrides = {
    gemini = {
      model = "gemini-2.5-pro"
    },
    cursor = {
      additional_rules = "Use functional components"
    }
  }
}
```

### 2. Universal Instructions (`.ai/AGENTS.md`)

**Works with 8+ tools** (Codex, Copilot, Jules, Cursor, Aider, etc.):

```markdown
# Build & Test
```bash
npm install
npm run build
npm test
```

# Architecture
- /src - Application code
- /lib - Shared utilities
- /tests - Test suites

# Conventions
- Use TypeScript strict mode
- 2-space indentation
- Functional components for React
```

### 3. Transformers (Nushell Functions)

**Translate canonical config to tool-specific formats:**

```nushell
# Transform .ai/config.ncl → .ai/cursor/mcp.json
export def "transform cursor-mcp" [] {
  let config = (nickel export .ai/config.ncl)

  # Extract MCP servers
  let mcp = ($config | get mcp_servers)

  # Format for Cursor
  { mcpServers: $mcp } | save .ai/cursor/mcp.json
}

# Transform .ai/config.ncl → .ai/gemini/settings.json
export def "transform gemini-settings" [] {
  let config = (nickel export .ai/config.ncl)

  {
    model: ($config.tool_overrides.gemini.model),
    mcpServers: ($config.mcp_servers)
  } | save .ai/gemini/settings.json
}

# Transform .ai/AGENTS.md → .ai/claude/CLAUDE.md
export def "transform claude-md" [] {
  let agents = (open .ai/AGENTS.md)
  let claude_specific = (try { open .ai/context/claude.md } catch { "" })

  [$agents, $claude_specific] | str join "\n\n" | save .ai/claude/CLAUDE.md
}
```

### 4. Symlinks to Expected Locations

**Tools expect files at specific locations:**

```bash
# After transformation, create symlinks
ln -sf .ai/cursor/mcp.json .cursor/mcp.json
ln -sf .ai/cursor/cli.json .cursor/cli.json
ln -sf .ai/gemini/settings.json .gemini/settings.json
ln -sf .ai/claude/CLAUDE.md ./CLAUDE.md
ln -sf .ai/AGENTS.md ./AGENTS.md
```

**OR** configure tools to read from `.ai/` directly (if supported)

---

## Detailed Structure

### Complete `.ai/` Directory

```
.ai/
├── config.ncl                    # 🎯 CANONICAL - Single source of truth
├── AGENTS.md                     # 🌐 UNIVERSAL - Works with 8+ tools
│
├── context/                      # Additional context files
│   ├── architecture.md
│   ├── conventions.md
│   └── security.md
│
├── schemas/                      # Nickel schemas for validation
│   ├── mcp_servers.ncl
│   ├── permissions.ncl
│   └── config.ncl
│
├── .generated/                   # 🤖 AUTO-GENERATED (gitignored)
│   ├── cursor/
│   │   ├── mcp.json             # Generated from config.ncl
│   │   └── cli.json             # Generated from config.ncl
│   ├── gemini/
│   │   └── settings.json        # Generated from config.ncl
│   ├── claude/
│   │   └── CLAUDE.md            # Generated from AGENTS.md + context
│   ├── vscode/
│   │   └── settings.json        # Generated from config.ncl
│   ├── amp/
│   │   └── settings.json        # Generated from config.ncl
│   └── cursorrules              # Generated from AGENTS.md + context
│
└── cache/                        # Runtime cache (gitignored)
    └── .gitkeep
```

### What Gets Version Controlled

```gitignore
# .gitignore

# Keep canonical configs
!.ai/config.ncl
!.ai/AGENTS.md
!.ai/context/
!.ai/schemas/

# Ignore generated files
.ai/.generated/
.ai/cache/

# Ignore old root dotfiles (if they exist)
.cursor/
.gemini/
.amp/
.cursorrules
CLAUDE.md (if symlink)
GEMINI.md (if symlink)
```

**Result:** Only source configs are versioned, generated files are ephemeral

---

## Transformer System

### Concept

**Like a build system for configs:**
- **Input:** `.ai/config.ncl` (canonical)
- **Process:** Transform via Nushell functions
- **Output:** Tool-specific files in `.ai/.generated/<tool>/`

### Transformer Registry

```nushell
# nu/transformers/registry.ncl
{
  transformers = {
    cursor-mcp = {
      input = "config.ncl",
      output = ".generated/cursor/mcp.json",
      function = "transform cursor-mcp",
      format = "json"
    },
    cursor-cli = {
      input = "config.ncl",
      output = ".generated/cursor/cli.json",
      function = "transform cursor-cli",
      format = "json"
    },
    gemini-settings = {
      input = "config.ncl",
      output = ".generated/gemini/settings.json",
      function = "transform gemini-settings",
      format = "json"
    },
    claude-md = {
      input = ["AGENTS.md", "context/claude.md"],
      output = ".generated/claude/CLAUDE.md",
      function = "transform claude-md",
      format = "markdown"
    },
    agents-md = {
      input = "AGENTS.md",
      output = "../AGENTS.md",  # Symlink at root
      function = "copy",
      format = "markdown"
    }
  }
}
```

### Transform All

```nushell
# Run all transformers
export def "ai transform" [] {
  print "🔄 Transforming canonical config to tool-specific formats..."

  transform cursor-mcp
  transform cursor-cli
  transform gemini-settings
  transform claude-md
  transform vscode-settings
  transform amp-settings

  print "✅ All transformers complete!"
}

# Watch for changes and auto-transform
export def "ai watch" [] {
  print "👀 Watching .ai/config.ncl for changes..."

  while true {
    if (file-changed? .ai/config.ncl) {
      ai transform
    }
    sleep 1sec
  }
}
```

---

## Workflow

### 1. Initialize New Project

```bash
# Bootstrap .ai/ directory
ai init

# Creates:
# - .ai/config.ncl (template)
# - .ai/AGENTS.md (template)
# - .ai/schemas/ (validation)
```

### 2. Configure Once

Edit `.ai/config.ncl`:
```nickel
{
  mcp_servers = {
    github = {
      command = "npx",
      args = ["-y", "@modelcontextprotocol/server-github"],
      env = { GITHUB_TOKEN = "${GITHUB_TOKEN}" }
    }
  }
}
```

### 3. Transform

```bash
# Generate all tool-specific configs
ai transform

# Or auto-transform on save
ai watch
```

### 4. Tools Work Automatically

```bash
# Cursor reads .ai/.generated/cursor/mcp.json (via symlink)
cursor .

# Gemini CLI reads .ai/.generated/gemini/settings.json (via symlink)
gemini chat

# Claude Code reads AGENTS.md at root (symlink)
claude-code .
```

---

## Benefits

### 1. Clean Project Root ✨

**Before:**
```
project-root/
├── .cursor/
├── .gemini/
├── .amp/
├── .cursorrules
├── CLAUDE.md
├── GEMINI.md
├── AGENTS.md
├── .vscode/
└── ... (8+ AI-related files)
```

**After:**
```
project-root/
├── .ai/              # Everything in one place
└── AGENTS.md         # Only universal file at root (symlink)
```

### 2. Single Source of Truth 🎯

**Write once:**
```nickel
# .ai/config.ncl
mcp_servers.github = { ... }
```

**Works everywhere:**
- Cursor uses it
- Gemini uses it
- Claude uses it
- VS Code uses it
- New tool tomorrow? Just add transformer

### 3. Easy Version Control 📦

```bash
git add .ai/config.ncl .ai/AGENTS.md
# Generated files are gitignored
```

### 4. Like Dotfiles Management 🏠

**Similar to:**
- GNU Stow - Symlink management
- chezmoi - Template-based dotfiles
- home-manager - Nix-based config management

**But for AI tools!**

### 5. Extensible 🔌

**Add new tool:**
1. Write transformer function
2. Register in registry
3. Run `ai transform`
4. Done!

---

## Comparison to Existing Approaches

### AGENTS.md Approach
**What it does:**
- Universal instruction file
- Works with 8+ tools
- Simple Markdown

**What it doesn't do:**
- Tool-specific configs (MCP servers, permissions)
- Type validation
- Format translation

### lib-ai Approach
**What it does:**
- Universal instructions (via AGENTS.md)
- Tool-specific configs (via transformers)
- Type validation (via Nickel contracts)
- Format translation (JSON, TOML, YAML, Markdown)
- Centralized management (everything under `.ai/`)
- Clean project root

**Superset of AGENTS.md!**

---

## Migration Path

### From Existing Projects

```bash
# 1. Detect existing configs
ai detect

# Finds:
# - .cursor/mcp.json
# - .gemini/settings.json
# - CLAUDE.md
# - etc.

# 2. Import into canonical format
ai import

# Creates:
# - .ai/config.ncl (merged from all tools)
# - .ai/AGENTS.md (merged from CLAUDE.md, GEMINI.md, etc.)

# 3. Transform back to verify
ai transform

# 4. Compare
diff .cursor/mcp.json .ai/.generated/cursor/mcp.json

# 5. If good, replace with symlinks
ai finalize
```

---

## Implementation Phases

### Phase 1: Core Transformers
- [x] Research tool conventions ✅
- [ ] Define Nickel schemas
- [ ] Implement basic transformers (Cursor, Gemini, Claude)
- [ ] Test round-trip (canonical → tool → canonical)

### Phase 2: Tooling
- [ ] `ai init` - Bootstrap new projects
- [ ] `ai transform` - Run transformers
- [ ] `ai watch` - Auto-transform on changes
- [ ] `ai validate` - Check Nickel contracts

### Phase 3: Migration
- [ ] `ai detect` - Find existing configs
- [ ] `ai import` - Merge into canonical
- [ ] `ai finalize` - Replace with symlinks

### Phase 4: Ecosystem
- [ ] Add more tool transformers
- [ ] Community transformer registry
- [ ] VS Code extension (syntax highlighting)
- [ ] GitHub Action (validate on PR)

---

## Example: Real-World Project

### Before lib-ai
```
my-project/
├── .cursor/
│   ├── mcp.json (35 lines, MCP servers)
│   └── cli.json (20 lines, permissions)
├── .gemini/
│   └── settings.json (40 lines, MCP + model config)
├── .amp/
│   └── settings.json (60 lines, MCP + permissions + tools)
├── .vscode/
│   └── settings.json (80 lines, editor + MCP)
├── .cursorrules (50 lines, instructions)
├── CLAUDE.md (100 lines, instructions)
├── GEMINI.md (80 lines, instructions)
└── AGENTS.md (70 lines, instructions)

Total: 8 files, ~535 lines, lots of duplication
```

### After lib-ai
```
my-project/
├── .ai/
│   ├── config.ncl (120 lines, ALL config)
│   ├── AGENTS.md (100 lines, ALL instructions)
│   ├── .generated/ (auto-generated, gitignored)
│   │   ├── cursor/
│   │   ├── gemini/
│   │   ├── claude/
│   │   └── vscode/
│   └── schemas/ (validation)
└── AGENTS.md → .ai/AGENTS.md (symlink)

Total: 2 source files, ~220 lines, no duplication
Savings: ~60% fewer lines, single source of truth
```

---

## Key Technologies

### Nickel (Configuration)
- Schema validation via contracts
- Merging semantics for composition
- Type safety
- JSON/YAML/TOML export

### Nushell (Transformers)
- Structured data pipelines
- Cross-platform scripting
- Native JSON/YAML/TOML support
- Easy to extend

### Nix (Packaging)
- Reproducible builds
- Hermetic environments
- Cross-platform support
- Tool version pinning

---

## FAQ

### Q: Why not just use AGENTS.md everywhere?
**A:** AGENTS.md is great for instructions, but doesn't handle:
- MCP server definitions
- Permissions/security
- Model configuration
- Editor preferences
- Tool-specific settings

lib-ai uses AGENTS.md for instructions + adds config management.

### Q: Do tools need to support `.ai/` directory?
**A:** No! Transformers generate files in tool-expected locations (via symlinks or direct paths). Tools work without modification.

### Q: What if a tool updates its format?
**A:** Update the transformer. Source config stays the same.

### Q: Can I still manually edit tool-specific files?
**A:** Yes, but changes will be overwritten on next transform. Better to update canonical config.

### Q: What about tool-specific features?
**A:** Use `tool_overrides` in config.ncl or create tool-specific sections.

---

**Status:** 🚧 Design complete, implementation ready to begin
**Next:** Define Nickel schemas and build first transformers
