# Development Roadmap

## Phase 1: Foundation (Week 1)

- [ ] Core Nickel types
  - [x] Agent, Skill, Tool, Router
  - [ ] Workflow, Message, Context
- [ ] Basic DAG generation
- [ ] Simple LLM call builder (Nix derivation)
- [ ] CLI skeleton (run, plan commands)

## Phase 2: Orchestration (Week 2)

- [ ] Workflow execution engine
- [ ] State management between steps
- [ ] Router implementations
  - [ ] Loop-erased (Wilson-style)
  - [ ] Round-robin
  - [ ] Claude-code-router (LLM-guided)
- [ ] Prompt generation library
- [ ] Context propagation

## Phase 3: Integration (Week 3)

- [ ] Tool support
  - [ ] MCP (Model Context Protocol)
  - [ ] HTTP APIs
  - [ ] Local filesystem
- [ ] Multi-agent coordination
- [ ] Parallel execution
- [ ] Error handling & retries

## Phase 4: Polish (Week 4)

- [ ] Comprehensive documentation
- [ ] Example gallery
  - [ ] Simple agent
  - [ ] Multi-step workflow
  - [ ] Agent-to-agent communication
  - [ ] Research pipeline
- [ ] Tests (Nickel type checks + Nix eval)
- [ ] Performance optimization
- [ ] CI/CD setup

## Future Enhancements

- [ ] Streaming LLM responses
- [ ] Conversation persistence
- [ ] Agent introspection/debugging
- [ ] Web UI for visualization
- [ ] Cloud provider integrations (AWS Bedrock, Azure OpenAI)
- [ ] Benchmarking suite
- [ ] Plugin system for custom routers/tools

## Open Questions to Resolve

1. **LLM API calls in Nix**: Fixed-output derivations vs impure?
2. **State persistence**: Nix store or external DB?
3. **Streaming**: Batch-only or support streaming?
4. **Secrets**: How to handle API keys securely?
5. **Retries**: Where to implement retry logic?

---

**Status**: Phase 1 - Initial implementation
**Updated**: 2025-11-15
