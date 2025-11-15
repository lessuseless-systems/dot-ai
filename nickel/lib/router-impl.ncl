# Router implementation logic

let Agent = import "../types/Agent.ncl" in
let Router = import "../types/Router.ncl" in

{
  # Loop-erased routing (Wilson-style random walk)
  loopErased | Agent -> Array String -> Array String = fun agent => fun candidates =>
    # Simplified implementation
    # In production would implement actual loop-erased random walk algorithm
    let
      walk = candidates,
      # Remove loops by keeping only last occurrence of each element
      deduped = std.array.fold_right
        (fun skill acc =>
          if std.array.any (fun s => s == skill) acc then
            acc
          else
            [skill] @ acc
        )
        []
        walk
    in
    deduped,

  # Round-robin routing
  roundRobin | Agent -> Number -> String = fun agent => fun index =>
    let
      skills = agent.skills |> std.array.map (fun s => s.name),
      idx = index % (std.array.length skills)
    in
    std.array.at idx skills,

  # Claude Code Router (LLM-guided)
  claudeCodeRouter | Agent -> String -> Context -> String
    = fun agent => fun input => fun ctx =>
      # Would call LLM to decide routing
      # For now, default to first skill
      (std.array.first agent.skills).name,

  # Select router implementation
  selectRouter | Router -> String = fun router =>
    match router.strategy {
      'LoopErased => "loop-erased",
      'RoundRobin => "round-robin",
      'ClaudeCodeRouter => "claude-code-router",
      'Custom => router.custom_logic |> std.option.unwrap_or "round-robin",
    },
}
