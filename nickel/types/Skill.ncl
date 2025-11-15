{
  # Skill type definition
  # Domain-specific capability that can be executed by an agent

  name | String,
  entry | String,  # Function entry point (e.g., "search.query", "text.summarize")
  config | {..} | default = {},  # Skill-specific configuration (flexible schema)

  # Optional fields
  description | String | optional,
  input_schema | {..} | optional,
  output_schema | {..} | optional,
}
