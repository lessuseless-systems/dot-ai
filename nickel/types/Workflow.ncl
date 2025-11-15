{
  # Workflow type definition
  # DAG of agent executions with state management

  name | String,

  steps | Array {
    agent | String,  # Agent name reference
    input | Dyn,     # Can be literal, context reference, or previous step output

    # Optional step configuration
    parallel | Bool | default = false,  # Run this step in parallel with others
    output_to | String | optional,      # Store output in context with this key
    condition | String | optional,      # Conditional execution (Nickel expression)
    retry | {
      max_attempts | Number | default = 3,
      backoff | [| 'Exponential, 'Linear, 'Constant |] | default = 'Exponential,
    } | optional,
  },

  router | Router,

  context | {
    # Initial context schema (user-defined)
    ..
  } | default = {},
}
