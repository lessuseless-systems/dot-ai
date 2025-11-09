# Library patterns: Multiple levels of abstraction

**Author:** Tomas Petricek

## Overview

Tomas Petricek explores a fundamental design principle for building functional libraries: organizing functionality across multiple abstraction levels to serve different user needs.

## Key Design Principles

The article identifies four essential library design principles:

1. **Iterative design** — Start with script files before building formal library projects
2. **Composability** — Expose simple building blocks rather than complex entry points
3. **Avoid callbacks** — Don't impose structural constraints that reduce flexibility
4. **Levels of abstraction** — Provide tiered APIs for different complexity needs

## The Core Pattern

Petricek proposes a structured approach: "At the highest level, you can handle the 80% of scenarios with just a single function call." Users needing more customization move deeper into progressively lower-level APIs, enabling the remaining use cases without limiting library design.

## Demonstration 1: Functional Lists

The F# list module exemplifies this pattern:

**High-level:** Higher-order functions like `List.map` and `List.filter` cover common scenarios elegantly.

**Low-level:** Recursion and pattern matching enable complex operations like splitting lists at sign changes—operations difficult with higher-order functions alone.

**Synthesis:** The library can expose new high-level functions (like `List.splitAt`) implemented using lower-level primitives, creating a feedback loop between abstraction levels.

## Demonstration 2: 3D Graphics

A castle-building library shows hierarchical abstraction:

- **Very-high-level:** Four lines create complete castles using domain vocabulary
- **High-level:** Composing primitives (cylinders, cones) into towers and walls
- **Low-level:** Direct OpenGL rendering calls

This structure lets users begin with castle-building idioms and descend to shape composition or rendering details as needed.

## Demonstration 3: Documentation Generation

The F# Formatting library demonstrates practical application:

**High-level:** `Literate.ProcessDirectory` converts entire folders to HTML with one call.

**Medium-level:** `Literate.ProcessMarkdown` processes individual files, enabling custom directory traversal (e.g., fetching files from GitHub rather than local folders).

**Low-level:** `ParseMarkdownFile` exposes parsed document structures for direct manipulation—allowing insertion of generated table-of-contents before rendering.

## Why This Matters

This design pattern yields significant benefits:

- Users solving standard problems enjoy simple, readable code
- Advanced users can customize behavior without restrictions
- Library developers aren't forced to predict every possible use case
- New high-level abstractions emerge organically from lower-level composition

## Counterexample: Reactive Extensions

The Reactive Extensions library illustrates a cautionary case. It provides "nice high-level abstraction" but lacks convenient lower-level APIs for implementing custom operators. The standard `Select` operator requires 125 lines of code despite being conceptually simple—indicating inadequate abstraction layering.

## Conclusion

Libraries with multiple abstraction levels transform documentation and flexibility. By exposing simpler components, developers enable users to "unroll" high-level operations into lower-level code, customize behavior, and "fold" solutions back into reusable abstractions. This approach balances ease of use with extensibility, making good libraries function as domain-specific languages.
