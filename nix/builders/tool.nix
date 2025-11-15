{ pkgs }:

{
  # Execute a local tool
  executeLocalTool = { name, command, args ? [ ], input ? "" }:
    pkgs.runCommand "tool-${name}" { } ''
      echo "[a-layer] Executing local tool: ${name}" >&2
      echo "[a-layer] Command: ${command}" >&2

      # Execute the tool command
      OUTPUT=$(${command} ${toString args} <<< "${input}" 2>&1 || echo "error")

      cat <<EOF > $out
{
  "tool": "${name}",
  "type": "local",
  "output": "$OUTPUT",
  "timestamp": "$(date -Iseconds)"
}
EOF
    '';

  # Call HTTP tool
  executeHttpTool = { name, url, method ? "GET", body ? null, headers ? { } }:
    pkgs.runCommand "tool-http-${name}" { } ''
      echo "[a-layer] HTTP tool call: ${name}" >&2
      echo "[a-layer] URL: ${url}" >&2
      echo "[a-layer] Method: ${method}" >&2

      # Make HTTP request using curl
      ${pkgs.curl}/bin/curl -X ${method} \
        ${if body != null then "-d '${builtins.toJSON body}'" else ""} \
        "${url}" > response.json 2>&1 || echo '{"error": "request failed"}' > response.json

      cat <<EOF > $out
{
  "tool": "${name}",
  "type": "http",
  "url": "${url}",
  "method": "${method}",
  "response": $(cat response.json),
  "timestamp": "$(date -Iseconds)"
}
EOF
    '';

  # Execute MCP tool
  executeMcpTool = { name, server, method, params ? { } }:
    pkgs.runCommand "tool-mcp-${name}" { } ''
      echo "[a-layer] MCP tool call: ${name}" >&2
      echo "[a-layer] Server: ${server}" >&2
      echo "[a-layer] Method: ${method}" >&2

      # TODO: Implement actual MCP protocol
      # For now, placeholder

      cat <<EOF > $out
{
  "tool": "${name}",
  "type": "mcp",
  "server": "${server}",
  "method": "${method}",
  "result": "MCP call placeholder",
  "timestamp": "$(date -Iseconds)"
}
EOF
    '';

  # Generic tool dispatcher
  executeTool = toolConfig: input:
    let
      kind = toolConfig.kind or "local";
    in
    if kind == "local" then
      executeLocalTool {
        name = toolConfig.name;
        command = toolConfig.entry;
        inherit input;
      }
    else if kind == "http" then
      executeHttpTool {
        name = toolConfig.name;
        url = toolConfig.entry;
        method = toolConfig.config.method or "GET";
      }
    else if kind == "mcp" then
      executeMcpTool {
        name = toolConfig.name;
        server = toolConfig.config.server;
        method = toolConfig.entry;
      }
    else
      throw "Unknown tool kind: ${kind}";
}
