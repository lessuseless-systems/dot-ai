# Agent Instruction File Conventions - Research Findings

**Research Date:** 2025-11-07
**Status:** Initial findings complete - basis for lib-ai design

---

## Executive Summary

After researching actual AI tool conventions, we found **3 confirmed patterns** and several emerging ones:

### ✅ Confirmed & Production-Ready
1. **Gemini CLI** - `GEMINI.md` (official, automatic, hierarchical)
2. **Cursor** - `.cursorrules` (automatic, massive ecosystem)
3. **Claude Code** - `CLAUDE.md` (emerging community convention)

### Key Finding
**Agent instruction files ARE real**, but each tool uses different conventions. There is **no universal standard yet**.

---

## Discovered Conventions

### 0. AGENTS.md (OpenAI Open Standard) - UNIVERSAL STANDARD 🌐

**Status:** ✅ OpenAI-backed open format, multi-tool support

**Pattern (Hierarchical):**
```
~/AGENTS.md                       # User-level (all projects)
project-root/AGENTS.md            # Project-level
package/AGENTS.md                 # Package-level (most specific wins)
AGENTS.override.md                # Takes priority over AGENTS.md
```

**How it works:**
- **Multi-tool support** - Works with 20+ tools
- **Hierarchical** - Reads nearest file in directory tree
- **Simple Markdown** - Standard format, any headings
- **Override mechanism** - AGENTS.override.md takes priority
- **Portable** - Designed for cross-tool compatibility

**Supported Tools:**
- OpenAI Codex ✅
- GitHub Copilot ✅ (official support as of Aug 2025)
- Google Jules ✅
- Cursor ✅
- Aider ✅
- RooCode ✅
- Zed ✅
- Factory AI ✅

**What to Include:**
- **Build & Test** - Exact compile and test commands
- **Architecture Overview** - Major modules description
- **Security** - Auth flows, API keys, sensitive data
- **Git Workflows** - Branching, commits, PR requirements
- **Conventions & Patterns** - Naming, folders, code style

**Best Practices:**
- Keep ≤ 150 lines (long files slow agents)
- Treat like code (PR review for changes)
- Use hierarchical structure for monorepos
- Update when build steps change

**Example:**
```markdown
# Build & Test
```bash
npm install
npm run build
npm test
```

# Architecture
- /src - Main application code
- /tests - Test suites
- /docs - Documentation

# Security
API keys in .env file (never commit)
Auth via OAuth 2.0

# Conventions
- PascalCase for components
- camelCase for functions
- 2-space indentation
```

**Competing Format:**
- AGENT.md (singular) - Alternative from agentmd/agent.md
- Addresses tool proliferation (.cursorrules, .windsurfrules, etc.)

**This is the emerging universal standard - supported by most major tools!**

---

### 1. GEMINI.md (Gemini CLI) - GOLD STANDARD ⭐

**Status:** ✅ Official feature with full documentation

**Pattern:**
```
~/.gemini/GEMINI.md              # Global context
project-root/GEMINI.md           # Project context
subdirs/GEMINI.md                # Module-specific context
```

**How it works:**
- **Automatic discovery** - no configuration needed
- **Hierarchical** - scans from home → project root → subdirectories
- **Concatenates all** - combines up to 200 files
- **Modular** - `@file.md` imports
- **Configurable** - can change filename via settings

**Special Features:**
- `/context` command to view loaded files
- `/compress` to summarize long context
- `@` symbol for file/dir inclusion
- UI shows count of loaded context files

**This is the most mature implementation.**

---

### 2. .cursorrules (Cursor AI) - LARGEST ECOSYSTEM 🌟

**Status:** ✅ Established with 1000+ community examples

**Pattern:**
```
project-root/.cursorrules         # Project instructions
```

**How it works:**
- **Automatic discovery** - reads from project root
- **Single file** - one .cursorrules per project
- **Plain text** - freeform instructions
- **No configuration** - just create the file

**Ecosystem:**
- **awesome-cursorrules** - 1000+ community rules
- **cursorrules-architect** - AI-powered generator
- **Framework-specific** - React, Vue, Angular, etc.
- **Agentic patterns** - Multi-agent management rules

**This has the most community adoption.**

---

### 3. CLAUDE.md (Claude Code) - OFFICIAL ANTHROPIC FEATURE ✅

**Status:** ✅ Officially documented by Anthropic

**Pattern (4-Tier Hierarchy):**
```
# 1. Enterprise (org-wide)
/Library/Application Support/ClaudeCode/CLAUDE.md    # macOS
/etc/claude-code/CLAUDE.md                           # Linux
C:\ProgramData\ClaudeCode\CLAUDE.md                  # Windows

# 2. Project (team-shared)
./CLAUDE.md                       # Project root
./.claude/CLAUDE.md               # Or in .claude/

# 3. User (personal, all projects)
~/.claude/CLAUDE.md

# 4. Project Local (deprecated)
./CLAUDE.local.md
```

**How it works:**
- **Automatic discovery** - recursive search from cwd upward
- **Hierarchical loading** - enterprise → user → project
- **Import syntax** - `@path/to/file` for modular imports (max depth 5)
- **Slash commands** - `/memory`, `/init`, `#` prefix for quick access
- **On-demand loading** - subdirectories loaded when accessed

**Discovery mechanism:**
- Recursively searches from cwd up to root (excluding `/`)
- Discovers files in subdirectories below cwd
- Loads project + user + enterprise memories
- Added as user message after system prompt

**Special features:**
- `/memory` - edit memory files in system editor
- `/init` - bootstrap new CLAUDE.md for project
- `#` prefix - quick file selection for adding memories
- Supports both relative and absolute paths in imports
- Can reference personal instructions outside repo

**This is an official, well-documented feature comparable to Gemini CLI.**

---

## Other Tools to Research

### High Priority (In nix-ai-tools)
- [ ] Aider - `.aider.conf.yml` (YAML config, needs instruction file research)
- [ ] Goose CLI - Unknown
- [ ] Crush - Unknown
- [ ] Amp - Unknown
- [ ] Copilot CLI - Unknown

### Lower Priority
- [ ] Continue.dev - Unknown
- [ ] Windsurf - Unknown
- [ ] Amazon Q - Unknown

---

## Pattern Analysis

### Common Elements

**File Naming:**
- Uppercase: `GEMINI.md`, `CLAUDE.md`
- Lowercase dotfile: `.cursorrules`
- Tool-specific: `.aider.conf.yml`

**Location:**
- Project root (all)
- User home (Gemini CLI)
- Subdirectories (Gemini CLI)

**Format:**
- Markdown (GEMINI.md, CLAUDE.md)
- Plain text (.cursorrules)
- YAML (.aider config)

**Discovery:**
- Automatic (Gemini, Cursor)
- Likely automatic (Claude)
- Configured (some tools)

### Divergences

**No Universal Standard:**
- Each tool picks own filename
- Different discovery mechanisms
- Different file formats
- Different scope support (hierarchical vs single)

**Precedence Models:**
- Gemini: Hierarchical concatenation
- Cursor: Single project file
- Claude: Unknown (probably single file)

---

## Recommendations for lib-ai

### Phase 1: Support Existing Conventions (Backward Compatible)

**Priority 1 - Translation Support:**

```
.ai/context/
├── general.md              # Shared across all agents
├── gemini.md               # Gemini-specific
├── claude.md               # Claude-specific
└── cursor.md               # Cursor-specific (becomes .cursorrules)
```

**Translation Logic:**
```
.ai/context/general.md + .ai/context/gemini.md → GEMINI.md
.ai/context/general.md + .ai/context/claude.md → CLAUDE.md
.ai/context/general.md + .ai/context/cursor.md → .cursorrules
```

**Advantages:**
- Works with existing tools immediately
- Users maintain one source (.ai/)
- Generated files kept in sync
- Tool-specific customization possible

### Phase 2: Propose Standard Convention

Based on Gemini CLI's mature implementation:

**Proposed Convention:**
```
# Filename: AGENT.md or .ai/instructions.md
# Location: Project root or .ai/
# Format: Markdown with optional front matter
# Discovery: Automatic by convention
# Scope: Project-level (with optional user-level)
```

**Advantages over current state:**
- Tool-agnostic location (`.ai/`)
- Single source of truth
- Markdown is universal
- Front matter for metadata
- Compatible with hierarchical systems

### Phase 3: Community Engagement

**Actions:**
1. Document discovered conventions
2. Propose unified standard
3. Submit PRs to tools:
   - Suggest `.ai/instructions.md` as fallback
   - Or read from `.ai/context/<tool>.md`
4. Build reference implementation in lib-ai
5. Advocate for adoption

---

## Design Implications for lib-ai

### Directory Structure

**Option A: Separate per-tool files**
```
.ai/
├── context/
│   ├── general.md          # All agents
│   ├── gemini.md           # Gemini-specific
│   ├── claude.md           # Claude-specific
│   └── cursor.md           # Cursor-specific
└── (other .ai files)
```

**Option B: Single file with sections**
```
.ai/
├── instructions.md         # All agent instructions
│   # Sections: ## General, ## Claude, ## Gemini
└── (other .ai files)
```

**Option C: Hybrid**
```
.ai/
├── context.md              # Default for all
├── context/
│   ├── claude.md           # Overrides/additions
│   └── gemini.md           # Overrides/additions
└── (other .ai files)
```

**Recommendation:** **Option A** (most flexible, matches Gemini's hierarchical model)

### Translation Strategy

**Gemini CLI:**
```nickel
# Merge and generate
.ai/context/general.md + .ai/context/gemini.md
  → GEMINI.md (at project root)
```

**Cursor:**
```nickel
# Merge and generate
.ai/context/general.md + .ai/context/cursor.md
  → .cursorrules (at project root)
```

**Claude Code:**
```nickel
# Merge and generate
.ai/context/general.md + .ai/context/claude.md
  → CLAUDE.md (at project root)
```

**Advantages:**
- DRY: Write shared context once
- Customization: Tool-specific additions
- Maintainable: One place to update general info
- Compatible: Works with existing tools

### Nickel Schema

```nickel
{
  AgentContext = {
    general | optional | String,      # Shared context
    tool_specific | optional | {
      _ | String,                     # Per-tool overrides
    },
    merge_strategy | [| 'append, 'prepend, 'replace |] = 'append,
  }
}
```

### Nu Translation Functions

```nushell
# Generate GEMINI.md from .ai/context/
export def generate-gemini-md [] {
  let general = (open .ai/context/general.md)
  let gemini = (try { open .ai/context/gemini.md } catch { "" })

  [$general, $gemini] | str join "\n\n" | save GEMINI.md
}

# Generate .cursorrules from .ai/context/
export def generate-cursorrules [] {
  let general = (open .ai/context/general.md)
  let cursor = (try { open .ai/context/cursor.md } catch { "" })

  [$general, $cursor] | str join "\n\n" | save .cursorrules
}
```

---

## Testing Plan

### Verify Conventions Work

For each confirmed pattern:

1. **Create test files:**
   ```bash
   mkdir test-project
   cd test-project
   echo "# Test Instructions" > GEMINI.md
   echo "# Test Instructions" > CLAUDE.md
   echo "# Test Instructions" > .cursorrules
   ```

2. **Run tools:**
   ```bash
   nix run github:numtide/nix-ai-tools#gemini-cli
   nix run github:numtide/nix-ai-tools#claude-code
   # Cursor requires IDE
   ```

3. **Verify:**
   - Tool reads the file
   - Instructions affect behavior
   - Context appears in prompts

### Test Translation

1. **Create .ai/context/ structure**
2. **Run lib-ai translator**
3. **Verify generated files match expected format**
4. **Test with actual tools**

---

## Next Steps

### Immediate (This Week)
- [x] Document discovered conventions
- [x] Create findings summary (this document)
- [ ] Test Gemini CLI with GEMINI.md
- [ ] Test Claude Code with CLAUDE.md (if available)
- [ ] Test Cursor with .cursorrules

### Short Term (This Month)
- [ ] Implement `.ai/context/` structure
- [ ] Build Nushell translation functions
- [ ] Define Nickel schemas
- [ ] Test full round-trip

### Long Term (Next Quarter)
- [ ] Propose standard to tool maintainers
- [ ] Build reference implementation
- [ ] Create documentation
- [ ] Advocate for adoption

---

## Key Takeaways

### What We Learned

1. **Agent instruction files ARE real** - not just a proposal
2. **Gemini CLI has the best implementation** - hierarchical, automatic, well-documented
3. **Cursor has the biggest ecosystem** - 1000+ community examples
4. **Claude Code convention is emerging** - growing adoption but unofficial
5. **No universal standard exists** - each tool does its own thing

### What lib-ai Should Do

1. **Support existing conventions first** - be backward compatible
2. **Provide translation layer** - `.ai/context/` → tool-specific files
3. **Propose unified standard** - based on best practices (Gemini model)
4. **Enable tool-agnostic workflows** - write once, deploy everywhere

### Success Criteria

- [ ] Users can write context once in `.ai/context/`
- [ ] lib-ai generates tool-specific files automatically
- [ ] Changes to `.ai/` propagate to all tools
- [ ] Tool-specific customizations supported
- [ ] Works with existing tool conventions

---

**Document Status:** ✅ Complete initial research
**Next Action:** Test Gemini CLI and Cursor with discovered patterns
**Impact:** Validates `.ai/context/` design in PLANNING.md
