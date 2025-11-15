{ pkgs }:

pkgs.writeShellScriptBin "a-layer-plan" ''
  #!${pkgs.bash}/bin/bash
  set -euo pipefail

  SPEC_FILE="''${1:-}"

  if [ -z "$SPEC_FILE" ]; then
    echo "Error: No specification file provided" >&2
    echo "Usage: a-layer plan <spec>" >&2
    exit 1
  fi

  if [ ! -f "$SPEC_FILE" ]; then
    echo "Error: File not found: $SPEC_FILE" >&2
    exit 1
  fi

  echo "[a-layer] Planning: $SPEC_FILE" >&2
  echo "" >&2

  # Evaluate Nickel spec
  SPEC_JSON=$(${pkgs.nickel}/bin/nickel export --format json "$SPEC_FILE")

  # Determine type
  TYPE=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r 'if .steps then "workflow" else "agent" end')

  if [ "$TYPE" = "workflow" ]; then
    NAME=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.name')
    STEPS=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.steps')
    NUM_STEPS=$(echo "$STEPS" | ${pkgs.jq}/bin/jq 'length')

    echo "Workflow: $NAME"
    echo "Steps: $NUM_STEPS"
    echo ""
    echo "Execution Plan:"
    echo "---------------"

    echo "$STEPS" | ${pkgs.jq}/bin/jq -r 'to_entries[] | "  \(.key + 1). \(.value.agent) (parallel: \(.value.parallel // false))"'

    echo ""
    echo "DAG Analysis:"
    echo "  - Total nodes: $NUM_STEPS"
    echo "  - Parallel opportunities: TBD"
    echo "  - Estimated cost: $NUM_STEPS LLM calls"
  else
    NAME=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.name')
    MODEL=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.model')
    SKILLS=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.skills')
    TOOLS=$(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.tools')

    echo "Agent: $NAME"
    echo "Model: $MODEL"
    echo ""
    echo "Skills:"
    echo "$SKILLS" | ${pkgs.jq}/bin/jq -r '.[] | "  - \(.name): \(.entry)"'

    echo ""
    echo "Tools:"
    echo "$TOOLS" | ${pkgs.jq}/bin/jq -r '.[] | "  - \(.name) (\(.kind))"'

    echo ""
    echo "Router: $(echo "$SPEC_JSON" | ${pkgs.jq}/bin/jq -r '.router.strategy')"
  fi
''
