# Prompt generation utilities

let Agent = import "../types/Agent.ncl" in
let Context = import "../types/Context.ncl" in

{
  # Generate system prompt for an agent
  systemPrompt | Agent -> String = fun agent =>
    let skills_list = agent.skills
      |> std.array.map (fun skill => "- %{skill.name}: %{skill.description |> std.option.unwrap_or ""}")
      |> std.string.join "\n"
    in
    let tools_list = agent.tools
      |> std.array.map (fun tool => "- %{tool.name} (%{std.to_string tool.kind})")
      |> std.string.join "\n"
    in
    "You are %{agent.name}, an AI agent with the following capabilities:\n\nSkills:\n%{skills_list}\n\nTools:\n%{tools_list}\n\nUse these skills and tools to complete tasks effectively.",

  # Generate user prompt with context
  userPrompt | String -> Context -> String = fun input => fun ctx =>
    let context_info = if std.record.has_field "previous" ctx && ctx.previous != null then
      "Previous output: %{std.serialize 'Json ctx.previous.output}"
    else
      ""
    in
    "%{input}\n\n%{context_info}",

  # Build complete prompt
  buildPrompt | Agent -> String -> Context -> {system | String, user | String}
    = fun agent => fun input => fun ctx => {
      system = systemPrompt agent,
      user = userPrompt input ctx,
    },

  # Template substitution
  substitute | String -> {..} -> String = fun template => fun vars =>
    # Simplified template substitution
    # In production would support {{var}} syntax
    template,
}
