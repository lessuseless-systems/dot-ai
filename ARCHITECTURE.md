# A-Layer: Nix+Nickel Agent Orchestration Library

## Vision

A pure Nix+Nickel library for declarative agent orchestration that can be used:
- **By agents** (agent-to-agent communication)
- **By humans** (CLI interface)
- **As a library** (Nix import for composition)

## Core Philosophy

**Nickel = "What"** (Declarative specification)
- Define agents, skills, tools, workflows
- Type-safe configuration
- Generate DAGs, prompts, execution plans

**Nix = "How"** (Execution runtime)
- Lazy evaluation optimizes execution
- Derivations materialize the DAG
- Caching prevents redundant LLM calls
- Natural parallelism

**No Rust** - Pure functional orchestration

## Architecture

```
┌─────────────────────────────────────────────┐
│  Nickel Spec (declarative agent/workflow)  │
└────────────┬────────────────────────────────┘
             │
             ├──→ CLI Mode: nix run .#a-layer
             ├──→ Library Mode: import in Nix
             └──→ Agent Mode: called by another agent
```

## Project Structure

```
a-layer/
├── flake.nix                    # Exports: apps (CLI), lib (functions), packages
│
├── nickel/
│   ├── types/
│   │   ├── Agent.ncl            # Agent schema
│   │   ├── Skill.ncl            # Skill definition
│   │   ├── Tool.ncl             # Tool types (mcp, local, http)
│   │   ├── Router.ncl           # Routing strategies
│   │   ├── Workflow.ncl         # Workflow composition
│   │   ├── Message.ncl          # Request/Response schemas
│   │   └── Context.ncl          # Execution context/state
│   │
│   ├── lib/
│   │   ├── orchestrator.ncl     # Core orchestration logic
│   │   ├── dag.ncl              # DAG construction utilities
│   │   ├── workflow.ncl         # Workflow composition
│   │   ├── prompt.ncl           # Prompt generation
│   │   ├── router-impl.ncl      # Router implementations (loop-erased, etc)
│   │   └── state.ncl            # State management between steps
│   │
│   └── examples/
│       ├── simple-agent.ncl
│       ├── workflow-chain.ncl
│       └── multi-agent.ncl
│
├── nix/
│   ├── lib/
│   │   ├── default.nix          # Public API exports
│   │   ├── agent-builder.nix    # Build agent from Nickel spec
│   │   ├── workflow-builder.nix # Build workflow from spec
│   │   └── runtime.nix          # Runtime utilities
│   │
│   ├── builders/
│   │   ├── llm.nix              # LLM API call derivations
│   │   ├── tool.nix             # Tool execution derivations
│   │   ├── workflow.nix         # Workflow execution
│   │   └── dag.nix              # DAG executor
│   │
│   └── cli/
│       ├── main.nix             # CLI entry point
│       └── commands/
│           ├── run.nix          # Execute agent/workflow
│           ├── plan.nix         # Show execution plan (dry-run)
│           ├── invoke.nix       # Invoke specific agent
│           └── compose.nix      # Interactive workflow builder
│
├── ARCHITECTURE.md              # This file
├── README.md                    # User documentation
└── ROADMAP.md                   # Development roadmap
```

## Usage Examples

### 1. CLI Mode (Human/Interactive)

```bash
# Run an agent
nix run .#a-layer -- run ./my-agent.ncl --input "Analyze this codebase"

# Show execution plan without running (dry-run)
nix run .#a-layer -- plan ./workflow.ncl

# Invoke specific skill on an agent
nix run .#a-layer -- invoke my-agent.research --input "quantum computing"

# Compose workflow interactively
nix run .#a-layer -- compose
```

### 2. Library Mode (Nix Import)

```nix
# flake.nix
{
  inputs.a-layer.url = "github:lessuseless-systems/a-layer";

  outputs = { self, a-layer, ... }: {
    # Build agent from Nickel spec
    researcher = a-layer.lib.buildAgent {
      spec = ./agents/researcher.ncl;
    };

    # Compose multi-agent workflow
    pipeline = a-layer.lib.composeWorkflow {
      agents = [ researcher analyzer summarizer ];
      router = "loop-erased";
    };

    # Execute and get result
    result = a-layer.lib.execute pipeline {
      input = "What is loop-erased random walk?";
    };
  };
}
```

### 3. Agent-to-Agent Mode (Nickel Workflow)

```nickel
# workflow-chain.ncl
{
  name = "research-pipeline",

  workflow = {
    steps = [
      {
        agent = "web-researcher",
        input = context.query,
        output_to = "research_results"
      },
      {
        agent = "fact-checker",
        input = previous.output,
        parallel = true,  # Run multiple fact-checkers concurrently
        output_to = "fact_check_results"
      },
      {
        agent = "summarizer",
        input = collect(previous),  # Collect parallel results
        output_to = "final_summary"
      }
    ],

    router = {
      strategy = "loop-erased",
      fallback = "round-robin"
    },

    context = {
      query | Str,
      max_iterations | Num | default = 3,
      temperature | Num | default = 0.7
    }
  }
}
```

### 4. Agent Specification (Nickel)

```nickel
# agents/researcher.ncl
{
  name = "web-researcher",
  model = "claude-3-5-sonnet-20241022",

  skills = [
    {
      name = "web-search",
      entry = "search.query",
      config = {
        max_results = 10,
        sources = ["arxiv", "github", "docs"]
      }
    },
    {
      name = "summarize",
      entry = "text.summarize",
      config = {
        max_length = 500
      }
    }
  ],

  tools = [
    {
      name = "web-fetch",
      kind = "http",
      entry = "https://api.example.com/fetch"
    },
    {
      name = "file-read",
      kind = "local",
      entry = "fs.read"
    }
  ],

  router = {
    strategy = "loop-erased",
    max_depth = 5
  }
}
```

## Design Principles

### 1. Pure Nickel = Declarative "What"
- Specs define structure, not execution
- Type-safe, validated before execution
- Generates DAGs, prompts, execution plans

### 2. Nix = Execution "How"
- Derivations materialize the DAG
- Lazy evaluation optimizes execution
- Caching prevents redundant work
- Natural parallelism for concurrent steps

### 3. Unified Interface
- Same spec works in all modes (CLI, library, agent-to-agent)
- CLI wraps library functions
- Agents call each other via Nix imports or Nickel composition

### 4. State Management
- Context flows through workflow
- Previous step outputs available to next
- Nix handles intermediate results
- Immutable by default

### 5. Composability
- Agents compose into workflows
- Workflows compose into pipelines
- Skills/tools are pluggable
- Routers are swappable

## Key Concepts

### Agent
A computation unit with:
- Model (LLM backend)
- Skills (domain capabilities)
- Tools (external integrations)
- Router (decision strategy)

### Workflow
A DAG of agent executions:
- Sequential steps
- Parallel execution
- Conditional branching
- State passing

### Router
Strategy for selecting skills/tools:
- `loop-erased`: Wilson-style random walk
- `round-robin`: Deterministic rotation
- `claude-code-router`: LLM-guided routing
- Custom: User-defined logic

### Skill
Domain-specific capability:
- Entry point (function name)
- Configuration
- Input/output schemas

### Tool
External integration:
- `mcp`: Model Context Protocol
- `local`: Filesystem/local commands
- `http`: REST APIs

### Context
Execution state:
- Input parameters
- Intermediate results
- Configuration
- Metadata

## Execution Flow

```
1. Parse Nickel spec
   ↓
2. Validate types
   ↓
3. Generate DAG
   ↓
4. Build Nix derivations
   ↓
5. Execute (lazy, cached, parallel)
   ↓
6. Return results
```

## Advantages of Nix+Nickel

**Type Safety**
- Nickel validates specs before execution
- Catch errors at "compile time"

**Caching**
- Nix caches LLM responses
- Avoid redundant API calls
- Reproducible results

**Parallelism**
- Nix naturally parallelizes independent steps
- Efficient resource utilization

**Composability**
- Flake inputs compose agents
- Workflows reference other workflows
- Library functions compose cleanly

**No Runtime**
- No daemon process
- No server to manage
- Just derivations

## Development Roadmap

### Phase 1: Foundation
- [ ] Core Nickel types (Agent, Skill, Tool, Router, Workflow)
- [ ] Basic DAG generation
- [ ] Simple LLM call builder
- [ ] CLI skeleton

### Phase 2: Orchestration
- [ ] Workflow execution
- [ ] State management
- [ ] Router implementations (loop-erased, round-robin)
- [ ] Prompt generation

### Phase 3: Integration
- [ ] MCP tool support
- [ ] HTTP tool support
- [ ] Local tool support
- [ ] Multi-agent coordination

### Phase 4: Polish
- [ ] Documentation
- [ ] Examples
- [ ] Tests (Nickel + Nix)
- [ ] Performance optimization

## Comparison to Other Frameworks

| Feature | A-Layer | LangChain | AutoGPT | Google ADK |
|---------|---------|-----------|---------|------------|
| Language | Nix+Nickel | Python | Python | Kotlin+YAML |
| Type Safety | ✓ | Partial | ✗ | ✓ |
| Caching | Native (Nix) | Manual | ✗ | Manual |
| Declarative | ✓ | ✗ | ✗ | Partial |
| CLI + Library | ✓ | Library only | CLI-focused | Library only |
| Agent-to-Agent | ✓ | Manual | ✗ | ✓ |
| Reproducible | ✓ (Nix) | ✗ | ✗ | Partial |

## Open Questions

1. **LLM API Calls in Nix**
   - Use fixed-output derivations?
   - External fetchers?
   - Impure derivations with `--impure`?

2. **State Persistence**
   - How to handle long-running conversations?
   - Store in Nix store or external DB?

3. **Streaming**
   - Can Nix handle streaming LLM responses?
   - Or batch only?

4. **Error Handling**
   - Retry logic in Nix?
   - Fallback strategies?

5. **Authentication**
   - API keys in Nix secrets?
   - Environment variables?
   - External secrets manager?

## License

MIT OR Apache-2.0

---

**Status**: Architecture design phase
**Next**: Begin Phase 1 implementation
