{ pkgs }:

pkgs.writeShellScriptBin "a-layer-run" ''
  #!${pkgs.bash}/bin/bash
  set -euo pipefail

  SPEC_FILE=""
  INPUT=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --input)
        INPUT="$2"
        shift 2
        ;;
      *)
        SPEC_FILE="$1"
        shift
        ;;
    esac
  done

  if [ -z "$SPEC_FILE" ]; then
    echo "Error: No specification file provided" >&2
    echo "Usage: a-layer run <spec> --input <text>" >&2
    exit 1
  fi

  if [ ! -f "$SPEC_FILE" ]; then
    echo "Error: File not found: $SPEC_FILE" >&2
    exit 1
  fi

  if [ -z "$INPUT" ]; then
    echo "Error: No input provided" >&2
    echo "Usage: a-layer run <spec> --input <text>" >&2
    exit 1
  fi

  echo "[a-layer] Running: $SPEC_FILE" >&2
  echo "[a-layer] Input: $INPUT" >&2
  echo "" >&2

  # Evaluate Nickel spec
  SPEC_JSON=$(${pkgs.nickel}/bin/nickel export --format json "$SPEC_FILE")

  # Determine if it's an agent or workflow
  TYPE=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r 'if .steps then "workflow" else "agent" end')

  echo "[a-layer] Type: $TYPE" >&2

  # Execute based on type
  if [ "$TYPE" = "workflow" ]; then
    WORKFLOW_NAME=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.name')
    NUM_STEPS=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.steps | length')

    echo "[a-layer] Workflow: $WORKFLOW_NAME" >&2
    echo "[a-layer] Steps: $NUM_STEPS" >&2
    echo "" >&2

    # TODO: Execute workflow
    cat <<EOF
{
  "type": "workflow",
  "name": "$WORKFLOW_NAME",
  "input": "$INPUT",
  "output": "Workflow execution not yet implemented",
  "steps_executed": $NUM_STEPS
}
EOF
  else
    AGENT_NAME=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.name')
    MODEL=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.model')

    echo "[a-layer] Agent: $AGENT_NAME" >&2
    echo "[a-layer] Model: $MODEL" >&2
    echo "" >&2

    # TODO: Execute agent
    cat <<EOF
{
  "type": "agent",
  "name": "$AGENT_NAME",
  "model": "$MODEL",
  "input": "$INPUT",
  "output": "Agent execution not yet implemented"
}
EOF
  fi
''
