---
created: 2025-11-06T23:48:10 (UTC -06:00)
tags: [nickel,configuration,Infrastructure as Code,DevOps,automation,Terraform,cloud,AWS,Kubernetes,GCP,Nix,Azure,CI/CD]
source: https://nickel-lang.org/user-manual/package-management/
author: 
---

# Nickel

> ## Excerpt
> Manage complex configurations. Modular, correct and boilerplate-free.

---
You are writing Nickel code and wonder how it should be annotated. Leave it alone? Add type annotations? Use contracts? Here is a quick guide when you don't know what to do!

What is the nature of the expression you are considering?

## [](https://nickel-lang.org/user-manual/package-management/#a-function)A function

Most of the time, you should use a **type annotation** for functions. For reusable code, typing is more adapted than contracts.

You can exceptionally use contracts when types are not expressive enough to encode the property you want (such as in `ValidUrl -> Port -> ValidUrl`) or if the type system is not powerful enough to see that your code is well-typed.

What to do depends on the context:

-   _Anonymous function: nothing_. Short anonymous functions can usually live without an annotation. Inside a typed block, they will be typechecked anyway. Outside, anonymous function can't be reused elsewhere, and are generally passed as arguments to a higher-order function, which should be typed and will apply a guarding contract.
    
    Example: `std.array.map (fun x => x + 1) [1,2,3]`
    
-   _Let-bound function outside typed block: use a type annotation._ Even if local to a file, if your function is bound to a variable, it can be potentially reused in different places.
    
    Example: `let append_tm: String -> String = fun s => "%{s} (TM)" in ...`
    
-   _Let-bound function inside a typed block: nothing or type annotation_. Inside a typed block, types are inferred, so it is OK for simple functions to not be annotated. However, you are required to annotate polymorphic functions, because the typechecker won't infer polymorphic types for you. When the function type is non-trivial, it can also be better to write an annotation for the sake of clarity.
    
    Example:
    
    ```kotlin
    > let foo : Number =
        let addTwo = fun x => x + 2 in
        addTwo 4
    
    > let foo : Number =
        let ev : ((Number -> Number) -> Number) -> Number -> Number
          = fun f x => f (std.function.const x) in
        ev (fun f => f 0) 1
    ```
    

## [](https://nickel-lang.org/user-manual/package-management/#data-records-and-arrays)Data (records and arrays)

Conversely, you should use **contracts** for data inside configuration code. Types are not adding much for configuration data, while contracts are more flexible and expressive.

Example:

```javascript
let Schema = {
  name
    | String
    | doc "Name of the package",
  version
    | PkgVersion
    | doc "The semantic version of the package"
    | default
    = "1.0.0",
  build
    | Array BuildSteps
    | doc "The steps to perform in order to build the package"
    | default
    = [],
}
in

{
  name = "hello",
  build = [
    command "gcc hello.c -o hello",
    command "mv hello $out"
  ],
} | Schema
```

## [](https://nickel-lang.org/user-manual/package-management/#computation-compound-expressions)Computation (compound expressions)

Some expressions are neither immediate data nor functions. Take for example the function application `std.array.map (fun s => "http://%{s}/index") servers`. Usually, you should do **nothing**.

-   _Inside configuration: nothing_. The function or operator you are using should be typed, and thus protected by a contract. The final value should also be protected by a contract, as per the advice on configuration code. Thus, for a simple computation like the example above, it is not necessary to add an annotation.
-   _Inside typed block: nothing_. Inside a typed block, the application will be inferred and typechecked, so you shouldn't have to add anything.

## [](https://nickel-lang.org/user-manual/package-management/#debugging)Debugging

At last, both type annotations and contracts come in handy for debugging. In this case, you don't have to follow the previous advice, and you can add type and contract annotations pretty much anywhere you see fit.

One useful pattern is to use a type wildcard `_`, which lets the typechecker figure out the type of an expression for you. If a dynamically typed expression is failing with an unhelpful error message, you can try to have it typechecked by simply appending `: _` to the expression.
