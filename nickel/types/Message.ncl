{
  # Message type definition
  # Request/Response format for agent communication

  id | String,
  timestamp | String,  # ISO 8601 format

  # Message type
  type | [| 'Request, 'Response, 'Error |],

  # Content
  content | {
    # For Request
    input | String | optional,
    agent | String | optional,
    skill | String | optional,

    # For Response
    output | String | optional,
    metadata | {..} | optional,

    # For Error
    error | String | optional,
    code | String | optional,

    ..
  },

  # Tracing
  parent_id | String | optional,  # For tracing request chains
  trace_id | String | optional,   # For distributed tracing
}
