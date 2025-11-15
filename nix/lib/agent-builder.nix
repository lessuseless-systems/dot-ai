{ pkgs, nickelPkg }:

let
  llmBuilder = import ../builders/llm.nix { inherit pkgs; };
in
{
  # Build an agent from Nickel specification
  buildAgent = { spec, name ? "agent" }:
    let
      # Evaluate Nickel spec to JSON
      agentSpec = pkgs.runCommand "agent-spec-${name}" { } ''
        ${nickelPkg}/bin/nickel export --format json ${spec} > $out
      '';

      # Parse JSON spec
      agentConfig = builtins.fromJSON (builtins.readFile agentSpec);

      # Build agent executor
      executor = pkgs.writeShellScriptBin "agent-${name}" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        INPUT="$1"
        AGENT_NAME="${agentConfig.name}"
        MODEL="${agentConfig.model}"

        echo "[a-layer] Executing agent: $AGENT_NAME" >&2
        echo "[a-layer] Model: $MODEL" >&2
        echo "[a-layer] Input: $INPUT" >&2

        # TODO: Implement actual LLM call
        # For now, just echo the configuration
        cat <<EOF
{
  "agent": "$AGENT_NAME",
  "model": "$MODEL",
  "input": "$INPUT",
  "output": "Agent executed successfully (placeholder)"
}
EOF
      '';
    in
    {
      inherit name;
      inherit executor;
      config = agentConfig;

      # Execute the agent
      execute = input: llmBuilder.callLLM {
        model = agentConfig.model;
        prompt = input;
        inherit name;
      };
    };
}
