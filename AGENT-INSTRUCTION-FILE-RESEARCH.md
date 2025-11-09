# Agent Instruction File Convention Research

**Purpose:** Discover what conventions actually exist for agent instruction files (CLAUDE.md, GEMINI.md, etc.)

**Created:** 2025-11-07
**Status:** Research in progress

---

## Research Question

**Do AI tools actually read project-level instruction files like `CLAUDE.md`, `GEMINI.md`, `QWEN.md`, `AGENTS.md`?**

If so:
- Which tools support this?
- What file naming conventions exist?
- What scope (user vs project)?
- What format/structure is expected?
- How are they referenced/discovered?
- Are they automatic or require configuration?

---

## Known Evidence

### From AI Tool Dotfile Configuration Research

**Gemini CLI:**
- Research doc states: "manages references to custom, informational context files, such as a project-specific GEMINI.md"
- Config path: `.gemini/settings.json`
- Reference mechanism: Settings file points to context file
- **Inference:** Not automatic - requires explicit configuration reference

**Proposed .ai Structure:**
- `agent_context.md` - "Standardized Markdown file used to convey high-level instructions, system prompts, or architectural context to any agent"
- Addresses "need identified by the Gemini CLI to link to project-specific context documentation"

### From PLANNING.md

**Agent Instruction Files listed:**
```
project-root/
├── CLAUDE.md                   # Claude-specific instructions
├── GEMINI.md                   # Gemini-specific instructions
├── QWEN.md                     # Qwen-specific instructions
└── AGENTS.md                   # General agent instructions
```

**Pattern:** Markdown files at project root with agent name in filename

### Questions to Answer

1. **Automatic vs Configured**
   - Do tools automatically read `TOOL.md` at project root?
   - Or must file be referenced in tool's config?

2. **Naming Conventions**
   - Uppercase: `CLAUDE.md` vs lowercase: `claude.md`?
   - With extension: `.md` or without?
   - In subdirectory: `.claude/instructions.md`?

3. **Discovery Mechanism**
   - Tools search for file by name?
   - Configured in `settings.json`?
   - Environment variable?
   - CLI flag?

4. **Scope**
   - Project-level only?
   - User-level too (`~/.claude.md`)?
   - Both with precedence?

---

## Research Methodology

### 1. Check Tool Documentation

For each tool, search official docs for:
- "instruction file"
- "context file"
- "system prompt file"
- "custom instructions"
- ".md file"
- "TOOL.md"

### 2. Test with Discovery Script

Modify `tools-discovery/discover.nu` to:
1. Create various instruction file patterns
2. Run tool
3. Check if file is read (via logs, config, behavior)

**Test files to create:**
```
TOOL.md
tool.md
TOOL.txt
.tool/instructions.md
.tool.md
INSTRUCTIONS.md
CONTEXT.md
```

### 3. Check Existing Projects

Search GitHub for real-world usage:
```
"CLAUDE.md" path:/
"GEMINI.md" path:/
"QWEN.md" path:/
".cursorrules" path:/
".aider.conf.yml" path:/
```

### 4. Examine Config Files

From discovered configs, look for:
- `contextFiles` key
- `instructionFile` key
- `systemPrompt` reference
- `customInstructions` field

---

## Findings by Tool

### Gemini CLI ✅ CONFIRMED

**Documentation Checked:** Yes
**Test Performed:** No (but officially documented)
**Real-world Examples:** Official Google repository

#### Support Status
- [x] Automatic file discovery (hierarchical)
- [x] Configured reference (fileName setting)
- [ ] No support found

#### File Naming
- **Default name:** `GEMINI.md` (uppercase)
- **Configurable:** Via `context.fileName` in settings.json
- **Location:** Multiple levels (hierarchical)

#### Discovery Mechanism
**Hierarchical Context System:**
1. **Global:** `~/.gemini/GEMINI.md`
2. **Project Root:** Searches from current dir up to `.git` folder
3. **Local:** Subdirectories below current working directory

**How it works:**
- Scans up to 200 directories (configurable via `memoryDiscoveryMaxDirs`)
- Concatenates all found GEMINI.md files
- Sends combined context with every prompt
- UI shows count of loaded context files in footer

#### Configuration Reference
```json
{
  "context": {
    "fileName": "GEMINI.md",
    "memoryDiscoveryMaxDirs": 200
  }
}
```

#### Scope
- **Project-level:** Yes (automatic discovery)
- **User-level:** Yes (`~/.gemini/GEMINI.md`)
- **Precedence:** All files concatenated (hierarchical merge)

#### Format
- **Format:** Markdown
- **Front matter:** Not mentioned
- **Special syntax:** `@file.md` for modular imports (Memory Import Processor)
- **Modular:** Can import other files

#### Example
```markdown
# Project Context

This is a Python project using FastAPI...

## Coding Standards
- Use type hints
- Follow PEP 8

@standards/python.md
```

#### Features
- **Context management:** `/context` command to view loaded files
- **Compression:** `/compress` to replace detailed content with summaries
- **@ Symbol:** Include files/directories in prompts
- **Hierarchical loading:** Global → Project → Local

#### Sources
- Official repo: https://github.com/google-gemini/gemini-cli/blob/main/GEMINI.md
- Docs: https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/gemini-md.md
- Configuration: https://geminicli.com/docs/get-started/configuration/

---

### Cursor (.cursorrules) ✅ CONFIRMED

**Documentation Checked:** Yes (community resources)
**Test Performed:** No
**Real-world Examples:** Hundreds (awesome-cursorrules)

#### Support Status
- [x] Automatic file discovery
- [ ] Configured reference
- [ ] No support found

#### File Naming
- **Name:** `.cursorrules` (dotfile, no extension)
- **Location:** Project root
- **Case:** Lowercase, starts with dot

#### Discovery Mechanism
- **Automatic:** Cursor AI reads `.cursorrules` from project root
- **No configuration needed**
- **Single file:** One .cursorrules per project

#### Scope
- **Project-level:** Yes (automatic)
- **User-level:** Unknown (needs research)
- **Precedence:** Project-level only

#### Format
- **Format:** Plain text (likely Markdown-ish)
- **Content:** Project-specific instructions for AI
- **Structure:** Freeform instructions

#### Example
```
You are working on a React TypeScript project.

Code Style:
- Use functional components
- Prefer hooks over classes
- Use absolute imports

Testing:
- Write tests for all components
- Use Jest and React Testing Library
```

#### Ecosystem
- **awesome-cursorrules:** 1000+ community rules
- **cursorrules-architect:** AI-powered generator
- **devin.cursorrules:** Replicates Devin-like capabilities
- **agentic-cursorrules:** Multi-agent management

#### Sources
- awesome-cursorrules: https://github.com/PatrickJS/awesome-cursorrules
- Generator: https://github.com/SlyyCooper/cursorrules-architect
- Devin rules: https://github.com/grapeot/devin.cursorrules

---

### Claude Code (CLAUDE.md) ✅ CONFIRMED - OFFICIAL

**Documentation Checked:** Yes (official Anthropic docs)
**Test Performed:** No
**Real-world Examples:** Official feature + community adoption

#### Support Status
- [x] Automatic file discovery (hierarchical, recursive)
- [x] Officially documented by Anthropic
- [x] Enterprise deployment support

#### File Naming
- **Name:** `CLAUDE.md` (uppercase, .md extension)
- **Variants:** `CLAUDE.local.md` (deprecated), `.claude/CLAUDE.md`
- **Location:** Multiple tiers (enterprise, user, project)

#### Discovery Mechanism
- **Automatic:** Recursive search from cwd upward to root (excluding `/`)
- **Hierarchical:** Loads enterprise → user → project
- **On-demand:** Subdirectories loaded when accessed
- **Import depth:** Maximum 5 levels of recursive imports

#### Scope (4-Tier System)
- **Enterprise-level:** `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS), `/etc/claude-code/CLAUDE.md` (Linux), `C:\ProgramData\ClaudeCode\CLAUDE.md` (Windows)
- **User-level:** `~/.claude/CLAUDE.md` (personal, all projects)
- **Project-level:** `./CLAUDE.md` or `./.claude/CLAUDE.md` (team-shared)
- **Project-local (deprecated):** `./CLAUDE.local.md`
- **Precedence:** Enterprise policies take precedence, hierarchical loading

#### Format
- **Format:** Markdown
- **Content:** Instructions, coding standards, quality gates, project context
- **Import syntax:** `@path/to/file` for modular composition
- **Import paths:** Both relative and absolute supported
- **Max depth:** 5 levels of recursive imports
- **Loading:** Added as user message following system prompt

#### Example Patterns

**Project-level guidance:**
```markdown
# Claude Code Instructions

## Project Context
This is a Python project using FastAPI...

## Coding Standards
- Use type hints
- Follow project conventions

## Quality Gates
- All code must have tests
- Must pass linting
```

**Organizational standards (from claude-code-optimisation):**
```markdown
# Organizational Claude Code Configuration

Establishes behavioral standards and quality gates
across all organization projects.
```

#### Slash Commands
- `/memory` - Edit memory files in system editor
- `/init` - Bootstrap new CLAUDE.md for project
- `#` prefix - Quick file selection for adding memories
- `/config` - Configure Claude Code settings

#### Real Examples
1. **basicmachines-co/basic-memory** - Member guidance
2. **modelcontextprotocol/python-sdk** - MCP SDK instructions
3. **JoeInnsp23/claude-code-optimisation** - Templates & usage guides
4. **laurynas-biveinis/dotfiles** - User-level configuration
5. **neverything/claude-code-laravel** - Laravel-specific setup

#### Sources
- **Official docs:** https://code.claude.com/docs/en/memory
- **Settings:** https://docs.claude.com/en/docs/claude-code/settings
- **Overview:** https://docs.claude.com/en/docs/claude-code/overview
- Community templates: https://github.com/JoeInnsp23/claude-code-optimisation

---

### Template
```markdown
## Tool Name

**Documentation Checked:** Yes/No
**Test Performed:** Yes/No
**Real-world Examples:** Count

### Support Status
- [ ] Automatic file discovery
- [ ] Configured reference
- [ ] No support found

### File Naming
- Expected name: `TOOL.md` / `tool.md` / other
- Location: Project root / subdirectory / user home

### Configuration Reference
```json
{
  "contextFile": "path/to/file.md"
}
```

### Discovery Mechanism
- How tool finds/reads the file

### Scope
- Project-level: Yes/No
- User-level: Yes/No
- Precedence: If both exist

### Format
- Plain text / Markdown / Structured
- Front matter support: Yes/No
- Special syntax: Any special markers/sections

### Example
```markdown
# My Project Context

This project does X...
```

### Sources
- Official docs: URL
- GitHub examples: URLs
- Community discussions: URLs
```

---

## Documented Conventions

### Cursor (.cursorrules)

**Status:** 🔍 Needs research

**Known:**
- Cursor has `.cursorrules` file convention
- Plain text file at project root
- Contains rules/instructions for Cursor AI

**To Research:**
- Is this automatically read?
- What syntax/format?
- User-level equivalent?

### Aider (.aider.conf.yml)

**Status:** 🔍 Needs research

**Known:**
- Aider uses `.aider.conf.yml` for configuration
- YAML format

**To Research:**
- Does it support instruction files?
- Separate instruction file or in config?

### Claude Desktop

**Status:** 🔍 Needs research

**To Research:**
- Does Claude Desktop read `CLAUDE.md`?
- Or only configured via claude_desktop_config.json?
- Any project-level instruction mechanism?

### Gemini CLI

**Status:** ⚠️ Partial

**Known from research doc:**
- Supports custom context files
- Referenced in `.gemini/settings.json`
- Example: `GEMINI.md`

**To Research:**
- What's the config syntax?
- Automatic discovery or only via config?
- Format requirements?

### Continue

**Status:** 🔍 Needs research

**To Research:**
- Instruction file support?
- Naming convention?
- How to configure?

### GitHub Copilot

**Status:** 🔍 Needs research

**To Research:**
- Does it read project context files?
- What mechanism?

---

## Emerging Patterns

As we research, document patterns that appear across multiple tools:

### Pattern 1: Dotfile Configuration Reference

**Tools:** Gemini CLI, (others?)

**Mechanism:**
```json
{
  "contextFiles": ["TOOL.md", "docs/architecture.md"]
}
```

**Characteristics:**
- Not automatic
- Explicit reference in tool config
- Supports multiple files
- Can be outside project root

### Pattern 2: Automatic Discovery

**Tools:** (TBD)

**Mechanism:**
- Tool checks for `TOOL.md` at project root on startup
- Reads automatically if present

**Characteristics:**
- No configuration needed
- Standard naming expected
- Project scope only

### Pattern 3: Dotfile Rules

**Tools:** Cursor (.cursorrules), (others?)

**Mechanism:**
- Special dotfile name (not config, not TOOL.md)
- Automatically read
- Plain text instructions

**Characteristics:**
- Tool-specific naming
- Automatic discovery
- Simple format

---

## Real-World Examples

### GitHub Search Results

```bash
# Search for common patterns
site:github.com "CLAUDE.md" path:/
site:github.com ".cursorrules" path:/
site:github.com "GEMINI.md" path:/
```

**Log findings here:**

#### CLAUDE.md
- Found: X repositories
- Usage pattern: ...
- Common content: ...

#### .cursorrules
- Found: X repositories
- Usage pattern: ...
- Common content: ...

---

## Testing Protocol

### Test Setup

For each tool in Tier 1:

1. **Create test project with instruction files:**
   ```bash
   mkdir test-project
   cd test-project

   # Create various patterns
   echo "# Claude Instructions" > CLAUDE.md
   echo "# Claude Instructions" > claude.md
   echo "# General Instructions" > AGENTS.md
   mkdir .claude
   echo "# Instructions" > .claude/instructions.md
   ```

2. **Run tool and observe:**
   ```bash
   # Does it read the file?
   # Does it create a file?
   # Does it reference in config?
   ```

3. **Check tool output/behavior:**
   - Any indication file was read?
   - Changed behavior vs without file?
   - Error messages about file?

4. **Examine created configs:**
   - Reference to instruction file?
   - Settings for custom context?

### Test Matrix

| Tool | TOOL.md | tool.md | .tool/inst.md | Config Ref | Auto Read | Notes |
|------|---------|---------|---------------|------------|-----------|-------|
| gemini-cli | ? | ? | ? | ? | ? | |
| claude-code | ? | ? | ? | ? | ? | |
| cursor-agent | ? | ? | ? | ? | ? | |
| amp | ? | ? | ? | ? | ? | |
| crush | ? | ? | ? | ? | ? | |

---

## Related Standards/Conventions

### README.md
- Universal project documentation convention
- Top-level overview
- Not agent-specific but provides context

### CONTRIBUTING.md
- Contributor guidelines
- Could provide agent context
- Standard location

### .editorconfig
- Editor configuration standard
- Demonstrates dotfile convention
- Tool-agnostic

### .gitignore
- Git-specific dotfile
- Shows precedent for tool-specific root files
- Automatic discovery by Git

### package.json, Cargo.toml, etc.
- Language-specific manifests
- Automatic discovery
- Structured format

---

## Hypothesis

Based on limited evidence, we hypothesize:

### Current State (Reality)
1. **Most tools don't automatically read `TOOL.md` files**
2. **Some tools support context files via configuration reference**
3. **A few tools have proprietary formats** (`.cursorrules`)
4. **No universal standard exists yet**

### Proposed Convention (What lib-ai should support)
1. **Support discovered patterns first** (backward compatible)
2. **Propose standard for missing pattern**
3. **Translation layer bridges gaps**

### What lib-ai Should Do

**Phase 1: Support What Exists**
- If tool supports config reference → translate from `.ai/agent_context.md`
- If tool has proprietary format → convert to/from that format
- If tool has no support → document as limitation

**Phase 2: Propose Standard**
- Define `.ai/context/` structure for multi-agent instructions
- Propose `AGENT.md` convention for tools to adopt
- Provide reference implementation

**Phase 3: Advocate Adoption**
- Submit PRs to tools to support convention
- Document in lib-ai usage
- Build ecosystem around standard

---

## Next Steps

### Immediate Research Tasks

1. **Search GitHub**
   - [ ] Search for `CLAUDE.md` in real repos
   - [ ] Search for `.cursorrules` examples
   - [ ] Search for `GEMINI.md` usage
   - [ ] Search for `.aider.conf.yml` examples

2. **Check Tool Docs**
   - [ ] Gemini CLI docs - context file configuration
   - [ ] Cursor docs - .cursorrules format
   - [ ] Claude Desktop docs - instruction files
   - [ ] Aider docs - configuration options
   - [ ] Continue.dev docs - context files

3. **Test Discovery**
   - [ ] Modify discover.nu to test instruction file patterns
   - [ ] Run against Tier 1 tools
   - [ ] Document which patterns work

4. **Synthesize Findings**
   - [ ] Document proven patterns
   - [ ] Identify gaps
   - [ ] Propose lib-ai convention

---

## Update Log

**2025-11-07:** Initial research document created
- Question formulated
- Methodology outlined
- Template for findings prepared

---

## Recommendations for lib-ai

*To be filled after research completes*

### What We Discovered Works
1. ...
2. ...

### What Doesn't Exist Yet
1. ...
2. ...

### What lib-ai Should Support
1. ...
2. ...

### Proposed Convention
```
.ai/
├── context/
│   ├── general.md           # All agents
│   ├── claude.md            # Claude-specific
│   ├── gemini.md            # Gemini-specific
│   └── qwen.md              # Qwen-specific
```

OR

```
project-root/
├── AGENTS.md                # Convention to propose
├── CLAUDE.md                # Tool-specific
└── .ai/
    └── (other configs)
```

### Translation Strategy
- How to convert `.ai/` to tool-specific formats
- How to handle tools with no support
- Backward compatibility approach

---

**Status:** 🚧 Research in progress
**Next Action:** Search GitHub for real-world usage patterns
