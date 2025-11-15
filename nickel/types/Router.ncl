{
  # Router type definition
  # Strategy for selecting which skill or tool to use

  strategy | [| 'LoopErased, 'RoundRobin, 'ClaudeCodeRouter, 'Custom |],

  # Optional configuration
  max_depth | Number | default = 5,
  fallback_strategy | [| 'LoopErased, 'RoundRobin, 'ClaudeCodeRouter |] | optional,

  # For custom routers
  custom_logic | String | optional,  # Path to Nickel function
}
