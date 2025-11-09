---
created: 2025-11-06T23:47:03 (UTC -06:00)
tags: [nickel,configuration,Infrastructure as Code,DevOps,automation,Terraform,cloud,AWS,Kubernetes,GCP,Nix,Azure,CI/CD]
source: https://nickel-lang.org/user-manual/package-management/
author: 
---

# Nickel

> ## Excerpt
> Manage complex configurations. Modular, correct and boilerplate-free.

---
## [](https://nickel-lang.org/user-manual/package-management/#the-nickel-user-manual)The Nickel User Manual

Nickel is a generic configuration language.

Its purpose is to automate the generation of static configuration files - think JSON, YAML, XML, or your favorite data representation language - that are then fed to another system. It is designed to have a simple, well-understood core: it is in essence JSON with functions.

Nickel's salient traits are:

-   **Lightweight**: Nickel is easy to embed. An interpreter should be simple to implement. The reference interpreter can be called from many programming languages.
-   **Composable code**: the basic building blocks for computing are functions. They are first-class citizens, which can be passed around, called and composed.
-   **Composable data**: the basic building blocks for data are records (called _objects_ in JSON). In Nickel, records can be merged at will, including associated metadata (documentation, default values, type contracts, etc).
-   **Typed, but only when it helps**: static types improve code quality, serve as documentation and eliminate bugs early. But application-specific self-contained code will always evaluate to the same value, so type errors will show up at runtime anyway. Some JSON is hard to type. There, types are only a burden. Whereas reusable code - that is, _functions_ - is evaluated on potentially infinitely many different inputs, and is impossible to test exhaustively. There, types are precious. Nickel has types, but you get to choose when you want it or not, and it handles safely the interaction between the typed and the untyped world.
-   **Design by contract**: complementary to the type system, contracts are a principled approach to checking assertions. The interpreter automatically inserts assertions at the boundary between typed and untyped code. Nickel lets users add arbitrary assertions of their own and easily understand why when assertions fail.

The motto guiding Nickel's design is: **Great defaults, design for extensibility**

There should be a standard, clear path for common things. There should be no arbitrary restrictions that limit what you can do the one day you need to go beyond.

## [](https://nickel-lang.org/user-manual/package-management/#use-cases)Use cases

Nickel is a good fit in any situation where you need to generate a complex configuration, be it for a single app, a machine, whole infrastructure, or a build system.

The motivating use cases are in particular:

-   The [Nix package manager](https://nixos.org/): Nix is a declarative package manager using its own language for specifying packages. Nickel is an evolution of the Nix language, while trying to overcome some of its limitations.
-   Infrastructure as code: infrastructure is becoming increasingly complex, requiring a rigorous approach to deployment, modification and configuration. This is where a declarative approach also shines, as adopted by [Terraform](https://www.terraform.io/), [NixOps](https://github.com/NixOS/nixops) or [Kubernetes](https://kubernetes.io/), all requiring potentially complex generation of configuration.
-   Build systems: build systems (like [Bazel](https://bazel.build/)) need a specification of the dependency graph.

## [](https://nickel-lang.org/user-manual/package-management/#getting-started)Getting started

To get a Nickel binary working and run you first program, please follow the [Getting Started](https://nickel-lang.org/getting-started) section of the website.

## [](https://nickel-lang.org/user-manual/package-management/#current-state-and-roadmap)Current state and roadmap

Since version 1.0 released in May 2023, the core design of the language is stable and Nickel is useful for real-world applications. The next steps we plan to work on are:

-   Custom merge functions (second part of the [overriding proposal](https://github.com/tweag/nickel/blob/9fd6e436c0db8f101d4eb26cf97c4993357a7c38/rfcs/001-overriding.md))
-   [Incremental evaluation](https://github.com/tweag/nickel/issues/1589): design an incremental evaluation model and a caching mechanism in order to perform fast re-evaluation upon small changes to a configuration.
-   Performance improvements

## [](https://nickel-lang.org/user-manual/package-management/#content)Content

This document is a detailed documentation on the main aspects of the language. It is composed of the following sections:

1.  [Tutorial](https://nickel-lang.org/user-manual/tutorial)
2.  [Command line interface](https://nickel-lang.org/user-manual/cli)
3.  [Syntax](https://nickel-lang.org/user-manual/syntax)
4.  [Merging](https://nickel-lang.org/user-manual/merging)
5.  [Modular configurations](https://nickel-lang.org/user-manual/modular-configurations)
6.  [Correctness](https://nickel-lang.org/user-manual/correctness)
7.  [Contracts](https://nickel-lang.org/user-manual/contracts)
8.  [Typing](https://nickel-lang.org/user-manual/typing)
9.  [Types vs. Contracts](https://nickel-lang.org/user-manual/types-vs-contracts)
10.  [Package management](https://nickel-lang.org/user-manual/package-management)
