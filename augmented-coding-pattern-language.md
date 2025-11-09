# Augmented Coding - A Pattern Language

By Gregor Riegler | 12 Jul 2025

## Overview

This article presents a comprehensive pattern language for augmented coding—using LLMs as collaborative agents to enhance software development while maintaining code quality.

## Core Concepts

**Augmentation as Self-Discovery**: The author describes augmented coding as "a learning process where we discover our habits, decisions and workflows and capture them into clear artifacts that are so precise that an agent can follow and thus imitate us."

**Key Principle**: Before delegating to an agent, developers should externalize their own reasoning step-by-step, effectively constructing "a functional representation of yourself."

## Major Pattern Categories

### Basics
- **Agent**: A loop facilitating dialogue between developer and language model with tool execution capabilities
- **To Augment Oneself**: Project your methodology to enable agent imitation

### Navigation & Process
- **HATEOAG** (Hypertext as Engine of Agent Guidance): Uses linked documentation to guide agent behavior
- **Starter Symbol**: Leading emojis declaring process state
- **Process File**: Externalized task descriptions with linked resources
- **Subagent/Subtask**: Fresh contexts via delegation to manage token budgets
- **Taskchain**: Sequential subtasks forming autonomous workflows
- **Loop**: Self-reinitating processes using cross-context memory
- **Condition**: Natural language decision-making in workflows
- **Goto**: Exit mechanisms for loops based on conditions
- **Orchestrator**: Master process launching sub-processes in correct sequence

### Memory & State
- **Cross-Context Memory**: Persistent files preserving facts between separate agent contexts
- **State Indicator**: State machine tracking via markers in shared memory
- **StateMachine as Tool**: Constraining agent actions through command-based tools

### Interactive Elements
- **Dialog**: Inviting agent critique and questions during ideation
- **Wake**: Signals prompting human attention when needed

## Process Evolution

The author emphasizes treating process definitions as code:
- Version controlled
- Incrementally improved through usage
- Refactored for clarity
- Split to prevent drift and cognitive overload
- Extracted for better coordination

## What Works Well

**Small, Focused Steps**: Break large problems into smallest possible increments; agents perform better with constrained scope.

**Test-First Development**: "No production code without a failing test" ensures continuous feedback and prevents breakage.

**Hypothesis Before Execution**: Have agents state expectations before running code, reducing recovery iterations.

**Ask, Don't Tell**: Instead of prescribing solutions, ask questions to leverage agent knowledge and keep solution spaces open.

**Constraints as Enablers**: Restrict agent capabilities (file access, available commands) to shape better, more reliable outputs.

**Refactor Guard**: Use micro code reviews for legacy refactoring to verify behavior preservation.

**Algorithmic Automation**: Favor deterministic automation over stochastic outputs; agents excel at writing automation.

**Stdout Distillation**: Reduce verbose output to essential signals, minimizing context contamination.

**CLI-First Tools**: Leverage command-line interfaces as agents' native environment.

## Philosophical Alignment

The author observes parallels with agile methodology: "inspect and adapt, continuous improvement, small steps, iterate, TDD." The contrast suggests many LLM tools mirror waterfall approaches despite LLMs' potential for iterative development.

## Key Influences

- LLewellyn Falco (starter symbols, output distillation)
- Kent Beck (augmented coding concept)
- Roo Code (subtasking patterns)
