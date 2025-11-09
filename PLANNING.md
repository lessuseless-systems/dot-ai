# lib-ai Planning Document

**Goal:** Create a nix+nu+nickel library for organizing AI tooling under project-level `.ai` directories and standardized agent instruction files.

**Design Philosophy:** Library, not framework. Follow Petricek's principles of composability, multiple abstraction levels, and user control.

---

## I. Language Role Distribution

### Nix (Package & Environment Layer)
**Responsibilities:**
- Package definitions for AI tools (Claude Code, Aider, etc.)
- Reproducible development environments
- Dependency management across heterogeneous tools
- Build and installation automation
- Version pinning and hermetic builds

**Why Nix:**
- Declarative package management
- Reproducibility guarantees
- Cross-platform support
- Composable package sets

### Nushell (Scripting & Orchestration Layer)
**Responsibilities:**
- CLI tools for project scaffolding
- Agent orchestration scripts
- Data transformation pipelines
- Interactive REPL for exploration
- Integration glue between tools

**Why Nushell:**
- Structured data as first-class (JSON/YAML/TOML native)
- Modern scripting with type awareness
- Pipeline-oriented (fits AI workflows)
- Good error messages
- Cross-platform

### Nickel (Configuration & Validation Layer)
**Responsibilities:**
- Schema definitions for .ai structure
- Agent instruction file validation
- Configuration merging and composition
- Contract enforcement for tool configs
- Documentation generation from schemas

**Why Nickel:**
- Gradual typing (contracts + types)
- Record merging semantics
- Configuration-first design
- JSON/YAML export
- Modular, composable configs

---

## II. High-Level Architecture

```
lib-ai/
├── nix/              # Nix package definitions & overlays
│   ├── packages/     # Individual AI tool packages
│   ├── shells/       # Development shell configurations
│   └── modules/      # NixOS/home-manager modules
│
├── nu/               # Nushell scripts & libraries
│   ├── lib/          # Core library functions
│   ├── commands/     # CLI commands (nu plugins)
│   └── templates/    # Project scaffolding templates
│
├── nickel/           # Nickel schemas & configurations
│   ├── schemas/      # Schema definitions for .ai
│   ├── contracts/    # Reusable contracts
│   └── templates/    # Config templates
│
└── docs/             # Documentation & examples
```

---

## III. The `.ai` Directory Structure

### Design Goals
1. **Convention-based discovery** - Tools find what they need by location
2. **Extensible** - Easy to add new tools without breaking existing ones
3. **Validated** - Nickel contracts ensure correctness
4. **Composable** - Merge configurations from multiple sources

### Proposed Structure

```
project-root/
├── .ai/
│   ├── config.ncl              # Main configuration (Nickel)
│   ├── manifest.ncl            # Dependencies & tool declarations
│   │
│   ├── agents/                 # Agent-specific configurations
│   │   ├── claude.ncl
│   │   ├── gemini.ncl
│   │   └── qwen.ncl
│   │
│   ├── prompts/                # Reusable prompt templates
│   │   ├── system/
│   │   ├── task/
│   │   └── shared/
│   │
│   ├── context/                # Context files for agents
│   │   ├── architecture.md
│   │   ├── conventions.md
│   │   └── state/              # Cross-context memory
│   │
│   ├── tools/                  # Tool-specific configs
│   │   ├── aider/
│   │   ├── cursor/
│   │   └── continue/
│   │
│   ├── workflows/              # Nickel workflow definitions
│   │   ├── review.ncl
│   │   ├── refactor.ncl
│   │   └── test.ncl
│   │
│   └── cache/                  # Local cache (gitignored)
│       └── .gitkeep
│
├── CLAUDE.md                   # Claude-specific instructions
├── GEMINI.md                   # Gemini-specific instructions
├── QWEN.md                     # Qwen-specific instructions
└── AGENTS.md                   # General agent instructions
```

---

## IV. Agent Instruction File Convention

### Schema Definition (Nickel)

```nickel
# schemas/agent-instruction.ncl
{
  AgentInstruction = {
    metadata | {
      agent | String,
      version | String,
      priority | optional | Number,  # For merging precedence
    },

    system_context | optional | {
      role | optional | String,
      constraints | optional | Array String,
      capabilities | optional | Array String,
    },

    project_context | {
      architecture | optional | String,
      conventions | optional | Array String,
      anti_patterns | optional | Array String,
    },

    workflows | optional | {
      _ | {  # Arbitrary workflow names
        description | String,
        steps | Array String,
        tools | optional | Array String,
      }
    },

    tools | optional | {
      _ | Dyn,  # Tool-specific config
    },

    extensions | optional | Dyn,  # Escape hatch
  }
}
```

### Markdown Front Matter + Body Pattern

```markdown
---
# Parsed as Nickel/YAML, validated against schema
agent: claude
version: "1.0"
priority: 10
---

# Claude Agent Instructions

## System Context
You are working on a Nix-based infrastructure project...

## Project Architecture
[Links to .ai/context/architecture.md]

## Workflows
### Code Review
1. Check types with `nix flake check`
2. Run tests with `nu scripts/test.nu`
...
```

---

## V. Abstraction Levels

Following Petricek's "multiple levels of abstraction" principle:

### Very High-Level (80% use cases)
**Target:** Users who want "batteries included"

```nushell
# Initialize a new AI-enabled project
ai init --template python-ml

# Run a workflow
ai workflow run review

# Query agent configurations
ai agents list
```

### High-Level (Customization)
**Target:** Users who need to configure but not deeply customize

```nushell
# Use Nickel to customize config
ai config edit agents/claude.ncl

# Merge additional context
ai context add ./custom-rules.md

# Template customization
ai template create my-workflow
```

### Medium-Level (Composition)
**Target:** Users building custom workflows

```nushell
# Compose Nickel configs programmatically
ai compose --base .ai/config.ncl --override ./overrides.ncl

# Run custom Nu scripts with lib-ai functions
use lib-ai *
let config = load-ai-config
```

### Low-Level (Full Control)
**Target:** Power users and library developers

```nickel
# Direct Nickel config manipulation
import ".ai/config.ncl" as base
let custom = {
  agents.claude.model = "claude-sonnet-4",
  workflows.custom = { ... }
}
base & custom
```

```nix
# Direct Nix package customization
{
  lib-ai-tools = pkgs.lib-ai.override {
    enableExperimental = true;
    customAgents = [ ./my-agent.nix ];
  };
}
```

---

## VI. Integration Patterns

### Pattern 1: Tool Registration
Tools declare their requirements via Nickel contracts:

```nickel
# tools/aider/schema.ncl
{
  AiderConfig = {
    model | String,
    edit_format | [| 'whole, 'diff, 'udiff |],
    auto_commits | Bool,
    gitignore | optional | Bool,
  }
}
```

### Pattern 2: Agent Discovery
Agents discover their configs via convention:

```nushell
# nu/lib/discovery.nu
export def find-agent-config [agent: string] {
  let candidates = [
    $"($env.PWD)/.ai/agents/($agent).ncl"
    $"($env.PWD)/($agent | str upcase).md"
    $"($env.HOME)/.config/ai/agents/($agent).ncl"
  ]

  $candidates | where { path exists } | first
}
```

### Pattern 3: Context Assembly
Assemble context from multiple sources with Nickel merging:

```nickel
# config.ncl
let base = import "schemas/base.ncl"
let agents = import "agents/"
let workflows = import "workflows/"

base & agents & workflows
```

### Pattern 4: Stateless Execution
Following UserJot's stateless subagent pattern:

```nushell
# Each workflow execution is pure
export def run-workflow [name: string, inputs: record] {
  let config = load-ai-config
  let workflow = $config.workflows | get $name

  # Execute in isolated context
  with-env { AI_WORKFLOW: $name } {
    execute-steps $workflow.steps $inputs
  }
}
```

---

## VII. Extension Points

### 1. Custom Agents
Users can add agents by:
- Creating `.ai/agents/my-agent.ncl`
- Adding `MY_AGENT.md` at project root
- Registering in `.ai/manifest.ncl`

### 2. Custom Workflows
```nickel
# .ai/workflows/custom.ncl
{
  custom_review = {
    description = "Custom review process",
    steps = [
      "lint",
      "type-check",
      "ai-review",
      "human-review"
    ],
    agents = ["claude"],
    tools = ["nix", "nu"]
  }
}
```

### 3. Custom Tools
Tools provide their own schema:
```nickel
# .ai/tools/mytool/config.ncl
{
  MyTool | {
    enabled | Bool,
    config_path | String,
    options | Dyn,
  }
}
```

### 4. Plugin System (Future)
```nix
# flake.nix
{
  inputs.lib-ai.url = "github:lessuseless-systems/lib-ai";
  inputs.ai-plugin-xyz.url = "github:...";

  outputs = { lib-ai, ai-plugin-xyz, ... }: {
    devShells.default = lib-ai.lib.mkAIShell {
      plugins = [ ai-plugin-xyz ];
    };
  };
}
```

---

## VIII. Key Design Decisions

### Decision 1: Nickel for Schemas, Not Tool Configs
**Rationale:** Tools often expect JSON/YAML. Nickel exports to these formats.
**Pattern:** `.ai/config.ncl` → compile → `.ai/.generated/*.json`

### Decision 2: Markdown Files as Primary Interface
**Rationale:** Human-readable, agent-parseable, version-controllable
**Pattern:** Front matter (structured) + body (natural language)

### Decision 3: Convention Over Configuration
**Rationale:** Reduce boilerplate, match Augmented Coding patterns
**Examples:**
- `CLAUDE.md` auto-discovered for Claude
- `.ai/prompts/system/` auto-loaded
- `workflows/*.ncl` auto-registered

### Decision 4: Stateless by Default
**Rationale:** Predictability, testability, parallelization
**Pattern:** State lives in `.ai/context/state/`, explicitly passed

### Decision 5: No Global State
**Rationale:** Project-level only (for now)
**Future:** Home-level can be added as override/fallback layer

---

## IX. Implementation Roadmap

### Phase 1: Foundation (Milestone 1)
- [ ] Define core Nickel schemas
  - [ ] Agent instruction schema
  - [ ] Workflow schema
  - [ ] Tool config schema
- [ ] Create Nix package structure
  - [ ] Flake setup
  - [ ] Package dependencies
- [ ] Basic Nu library functions
  - [ ] Config loading
  - [ ] Agent discovery
  - [ ] Template rendering

### Phase 2: Core Functionality (Milestone 2)
- [ ] Implement `.ai` directory scaffolding
  - [ ] `ai init` command
  - [ ] Template system
- [ ] Agent instruction file parsing
  - [ ] Markdown + front matter parser
  - [ ] Nickel validation
- [ ] Basic workflow execution
  - [ ] Step interpreter
  - [ ] Context assembly

### Phase 3: Integration (Milestone 3)
- [ ] Tool integrations
  - [ ] Claude Code
  - [ ] Aider
  - [ ] Cursor (config generation)
- [ ] Workflow library
  - [ ] Code review
  - [ ] Refactoring
  - [ ] Documentation generation
- [ ] Context management
  - [ ] State persistence
  - [ ] Cross-context memory

### Phase 4: Polish (Milestone 4)
- [ ] Documentation
  - [ ] User guide
  - [ ] API reference
  - [ ] Examples repository
- [ ] Testing
  - [ ] Schema validation tests
  - [ ] Integration tests
- [ ] Developer experience
  - [ ] LSP integration (Nickel)
  - [ ] Shell completions (Nu)
  - [ ] Error messages

### Phase 5: Extension System (Future)
- [ ] Plugin architecture
- [ ] Community agent templates
- [ ] Tool marketplace
- [ ] Home-level configuration

---

## X. Open Questions

1. **Caching Strategy:** Where should prompt cache metadata live? `.ai/cache/`?

2. **Secret Management:** How to handle API keys? Env vars? Nix secrets?

3. **Multi-Agent Coordination:** How do workflows coordinate multiple agents?

4. **Conflict Resolution:** When configs conflict (project vs tool), what wins?

5. **Migration Path:** How do users migrate existing setups?

6. **LSP Support:** Should we provide a language server for `.ai/*.ncl` files?

7. **Remote Configs:** Support fetching configs from registries/git?

---

## XI. Success Criteria

### For Users
- ✓ Initialize AI project in < 5 minutes
- ✓ Run common workflows with single command
- ✓ Override configs without touching library code
- ✓ Understand what's happening (transparency)

### For Developers
- ✓ Add new agent in < 30 minutes
- ✓ Create custom workflow without framework knowledge
- ✓ Compose library functions programmatically
- ✓ Debug configs with clear error messages

### For Library
- ✓ No global mutable state
- ✓ All operations pure/reproducible (via Nix)
- ✓ Composable at all levels
- ✓ Backward compatible within major version

---

## XII. Related Work & Inspiration

- **Nix Ecosystem:** NixOS modules, home-manager patterns
- **Nickel Examples:** Organist (AWS/Terraform), github-workflow package
- **Agent Patterns:** Anthropic's Building Effective Agents, UserJot best practices
- **Augmented Coding:** Gregor Riegler's pattern language
- **Library Design:** Tomas Petricek's abstraction levels

---

## XIII. Next Steps

1. **Validate Assumptions:** Review this plan, get feedback
2. **Spike Nickel Schemas:** Prototype key schema definitions
3. **Proof of Concept:** Build minimal working example
   - Simple `.ai/` structure
   - One agent (Claude)
   - One workflow (review)
4. **Iterate:** Refine based on actual usage

---

**Document Status:** Draft v0.1
**Last Updated:** 2025-11-07
**Next Review:** After initial feedback
