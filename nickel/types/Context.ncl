{
  # Context type definition
  # Execution state that flows through workflow steps

  # Current step information
  current_step | Number,
  total_steps | Number,

  # Input/Output
  input | Dyn,  # Original workflow input
  outputs | {..} | default = {},  # Keyed outputs from previous steps

  # Previous step result (convenience access)
  previous | {
    output | Dyn | optional,
    agent | String | optional,
    step_index | Number | optional,
  } | optional,

  # User-defined state
  state | {..} | default = {},

  # Metadata
  metadata | {
    workflow_id | String,
    started_at | String,  # ISO 8601 timestamp
    updated_at | String,  # ISO 8601 timestamp
    ..
  },
}
