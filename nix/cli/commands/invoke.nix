{ pkgs }:

pkgs.writeShellScriptBin "a-layer-invoke" ''
  #!${pkgs.bash}/bin/bash
  set -euo pipefail

  AGENT_SKILL=""
  INPUT=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --input)
        INPUT="$2"
        shift 2
        ;;
      *)
        AGENT_SKILL="$1"
        shift
        ;;
    esac
  done

  if [ -z "$AGENT_SKILL" ]; then
    echo "Error: No agent.skill specified" >&2
    echo "Usage: a-layer invoke <agent.skill> --input <text>" >&2
    exit 1
  fi

  if [ -z "$INPUT" ]; then
    echo "Error: No input provided" >&2
    echo "Usage: a-layer invoke <agent.skill> --input <text>" >&2
    exit 1
  fi

  # Parse agent.skill
  IFS='.' read -r AGENT SKILL <<< "$AGENT_SKILL"

  echo "[a-layer] Invoking: $AGENT.$SKILL" >&2
  echo "[a-layer] Input: $INPUT" >&2
  echo "" >&2

  # TODO: Look up agent spec and invoke specific skill
  cat <<EOF
{
  "agent": "$AGENT",
  "skill": "$SKILL",
  "input": "$INPUT",
  "output": "Skill invocation not yet implemented"
}
EOF
''
