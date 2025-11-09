# Library patterns: Why frameworks are evil

**Author:** Tomas Petricek
**Published:** March 4, 2015

## Overview

This article examines functional library design principles, focusing on composability and avoiding callbacks. The central thesis contrasts libraries with frameworks, arguing that libraries should be preferred because they maintain user control while remaining composable.

## Frameworks vs. Libraries

### Core Distinction

A framework controls program execution and requires implementations at specific extension points, whereas a library provides functions and types that user code calls as needed. "A framework defines a structure that you have to fill, while library has some structure that you have to build around."

### Why Frameworks Are Problematic

**Non-composability:** Frameworks cannot easily combine because each enforces its own control structure. Libraries allow multiple independent calls, enabling composition.

**Difficult exploration:** Frameworks are hard to test interactively. In contrast, libraries support interactive experimentation—loading them in environments like F# Interactive to try different inputs and observe behaviors.

**Structural constraints:** Frameworks shape code architecture, often requiring inheritance and mutable state. The XNA game example demonstrates this limitation, where developers must implement specific methods within a prescribed class structure.

## Practical Solutions

### Interactive Exploration

Libraries should support interactive usage. Examples include F# Formatting and FunScript, which can be loaded and tested immediately by referencing and calling entry-point functions.

### Using Simple Callbacks

Avoid multi-function callbacks that share state between them. When a function accepts multiple function arguments with interdependencies, consider decomposing it into simpler, composable operations with multiple abstraction levels.

### Inverting Control with Events and Async

Rather than implementing virtual methods, expose events and use asynchronous workflows. "By reversing the control, we can now easily write our own abstractions." This approach provides flexibility while maintaining composability.

### Multiple Abstraction Layers

Provide both low-level explicit operations and high-level convenience functions. "It is fine to have easy-to-use operation that takes a couple of other functions as a high-level abstraction, but there should be a simple and more explicit alternative!"

### Composable Design

Expose complete type information and conversion mechanisms allowing integration with complementary libraries. The FsLab example demonstrates composing data-science libraries through intermediate array representations.

## Summary

Libraries outperform frameworks by preserving user control and enabling composition. The article uses a travel analogy: package holidays mirror frameworks (structured but inflexible), while independent travel mirrors libraries (more work but complete control).
