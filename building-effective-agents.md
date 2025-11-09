# Building Effective AI Agents

## Overview

Published December 19, 2024

Anthropic's research reveals that successful LLM agent implementations rely on "simple, composable patterns rather than complex frameworks," based on work with dozens of development teams.

## Key Definitions

**Agentic Systems** encompass two distinct architectural approaches:

- **Workflows**: LLMs and tools orchestrated through predefined code paths
- **Agents**: Systems where LLMs dynamically control their own processes and tool usage

## When to Use Agents

Start with the simplest solution possible. Agentic systems trade latency and cost for improved task performance. Workflows suit well-defined tasks with predictable steps, while agents work better for open-ended problems requiring flexibility and model-driven decision-making.

## Recommended Frameworks

- LangGraph (LangChain)
- Amazon Bedrock's AI Agent framework
- Rivet (drag-and-drop GUI)
- Vellum (workflow testing tool)

**Caution**: Frameworks can obscure underlying prompts and responses. Start with LLM APIs directly—most patterns require only a few lines of code.

## Core Agentic Patterns

### 1. Augmented LLM (Building Block)
Enhanced LLMs with retrieval, tools, and memory capabilities. Focus on tailoring features to specific use cases and providing clear documentation.

### 2. Prompt Chaining (Workflow)
Decomposes tasks into sequential steps where each LLM call processes previous output. Ideal for fixed subtasks where latency tradeoff improves accuracy.

### 3. Routing (Workflow)
Classifies inputs and directs them to specialized followup tasks. Useful for customer support triage and model selection optimization (e.g., Haiku for simple queries, Sonnet for complex ones).

### 4. Parallelization (Workflow)
Two variations:
- **Sectioning**: Independent subtasks run simultaneously
- **Voting**: Same task executed multiple times for diverse outputs

### 5. Orchestrator-Workers (Workflow)
Central LLM dynamically breaks down tasks and delegates to worker LLMs. Suited for problems with unpredictable subtasks (coding, multi-source searches).

### 6. Evaluator-Optimizer (Workflow)
One LLM generates responses while another provides evaluation and feedback in loops. Effective with clear criteria and iterative refinement value.

### 7. Agents (Autonomous)
LLMs using tools based on environmental feedback in loops. Require "ground truth" from each step (tool results, code execution). Include human checkpoints and stopping conditions.

## Tool Design Best Practices

Tools deserve as much prompt engineering attention as overall prompts. Key principles:

- Give models sufficient tokens to think before writing
- Keep formats close to natural language patterns
- Avoid formatting overhead (line counting, excessive escaping)
- Include usage examples and clear boundaries
- Test extensively; use Anthropic's workbench
- Apply "poka-yoke" principles to reduce errors

Example: Anthropic's SWE-bench agent required absolute filepaths instead of relative ones—this single change eliminated path-related mistakes.

## Three Core Principles

1. **Simplicity**: Keep agent designs lean and maintainable
2. **Transparency**: Explicitly show planning steps
3. **Documentation**: Thoroughly craft agent-computer interfaces (ACI)

## Practical Applications

**Customer Support**: Combines chatbots with tool integration for accessing customer data, knowledge bases, and issuing refunds. Several companies use usage-based pricing, charging only for successful resolutions.

**Coding Agents**: Solve real GitHub issues via automated testing and iteration. Anthropic's implementation handles SWE-bench tasks, though human review remains essential for broader system alignment.

---

**Written by**: Erik Schluntz and Barry Zhang
