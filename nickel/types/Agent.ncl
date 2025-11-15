{
  # Agent type definition
  # Represents a computational unit with model, skills, tools, and routing strategy

  name | String,
  model | String,
  skills | Array Skill,
  tools | Array Tool,
  router | Router,

  # Optional configuration
  config | {
    temperature | Number | optional,
    max_tokens | Number | optional,
    top_p | Number | optional,
    ..
  } | optional,
}
