{
  # Tool type definition
  # External integration (MCP, HTTP, local filesystem)

  name | String,
  kind | [| 'Mcp, 'Local, 'Http |],  # Tool type (enum)
  entry | String,  # Entry point or URL

  # Optional configuration based on tool kind
  config | {
    # For HTTP tools
    method | [| 'GET, 'POST, 'PUT, 'DELETE |] | optional,
    headers | {..} | optional,

    # For MCP tools
    server | String | optional,

    # For local tools
    command | String | optional,
    args | Array String | optional,

    ..
  } | default = {},
}
