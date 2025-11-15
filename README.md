# A-Layer: Nix+Nickel Agent Orchestration

A pure functional library for declarative agent orchestration.

## Features

- **Declarative**: Define agents and workflows in type-safe Nickel
- **Composable**: Agents, skills, tools, and workflows compose naturally
- **Multi-interface**: Use as CLI, library, or agent-to-agent
- **Cached**: Nix caching prevents redundant LLM calls
- **Parallel**: Nix automatically parallelizes independent steps

## Quick Start

```bash
# Try the CLI
nix run github:lessuseless-systems/dot-ai -- run examples/simple-agent.ncl

# Or use in your flake
{
  inputs.a-layer.url = "github:lessuseless-systems/dot-ai";

  outputs = { a-layer, ... }: {
    myAgent = a-layer.lib.buildAgent {
      spec = ./my-agent.ncl;
    };
  };
}
```

## Documentation

- [Architecture Overview](./ARCHITECTURE.md) - Design philosophy and concepts
- [Roadmap](./ROADMAP.md) - Development plan
- [Examples](./nickel/examples/) - Sample agent specifications

## Usage Modes

### 1. CLI (Interactive)

```bash
# Run an agent
nix run .#a-layer -- run ./my-agent.ncl --input "Analyze this"

# Show execution plan
nix run .#a-layer -- plan ./workflow.ncl

# Invoke specific skill
nix run .#a-layer -- invoke my-agent.research --input "topic"
```

### 2. Library (Nix Flake)

```nix
{
  researcher = a-layer.lib.buildAgent {
    spec = ./agents/researcher.ncl;
  };

  result = a-layer.lib.execute researcher {
    input = "What is loop-erased random walk?";
  };
}
```

### 3. Agent-to-Agent (Nickel)

```nickel
{
  workflow = {
    steps = [
      { agent = "researcher", input = context.query },
      { agent = "analyzer", input = previous.output },
      { agent = "summarizer", input = previous.output }
    ]
  }
}
```

## Philosophy

**Nickel = "What"** (Declarative specification)
- Type-safe agent/workflow definitions
- Generate DAGs and execution plans

**Nix = "How"** (Execution runtime)
- Lazy evaluation
- Automatic caching
- Natural parallelism

## License

MIT OR Apache-2.0
