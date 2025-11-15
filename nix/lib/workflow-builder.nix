{ pkgs, nickelPkg }:

let
  agentBuilder = import ./agent-builder.nix { inherit pkgs nickelPkg; };
  dagExecutor = import ../builders/dag.nix { inherit pkgs; };
in
{
  # Build a workflow from Nickel specification
  buildWorkflow = { spec, name ? "workflow" }:
    let
      # Evaluate Nickel spec to JSON
      workflowSpec = pkgs.runCommand "workflow-spec-${name}" { } ''
        ${nickelPkg}/bin/nickel export --format json ${spec} > $out
      '';

      workflowConfig = builtins.fromJSON (builtins.readFile workflowSpec);

      # Build executor script
      executor = pkgs.writeShellScriptBin "workflow-${name}" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        INPUT="$1"
        WORKFLOW_NAME="${workflowConfig.name}"
        NUM_STEPS="${toString (builtins.length workflowConfig.steps)}"

        echo "[a-layer] Executing workflow: $WORKFLOW_NAME" >&2
        echo "[a-layer] Steps: $NUM_STEPS" >&2
        echo "[a-layer] Input: $INPUT" >&2

        # TODO: Implement actual workflow execution
        # For now, just echo the configuration
        cat <<EOF
{
  "workflow": "$WORKFLOW_NAME",
  "steps": $NUM_STEPS,
  "input": "$INPUT",
  "output": "Workflow executed successfully (placeholder)"
}
EOF
      '';
    in
    {
      inherit name;
      inherit executor;
      config = workflowConfig;

      # Execute the workflow
      execute = input: dagExecutor.executeDAG {
        inherit name;
        workflow = workflowConfig;
        input = input;
      };
    };

  # Compose multiple workflows
  composeWorkflows = { workflows, mode ? "sequential" }:
    let
      composedName = "composed-${toString (builtins.length workflows)}";
    in
    pkgs.writeShellScriptBin composedName ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      INPUT="$1"
      MODE="${mode}"

      echo "[a-layer] Composing ${toString (builtins.length workflows)} workflows" >&2
      echo "[a-layer] Mode: $MODE" >&2

      # TODO: Implement workflow composition
      echo '{"status": "composed", "mode": "${mode}"}'
    '';
}
