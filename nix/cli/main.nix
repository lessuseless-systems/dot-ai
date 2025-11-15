{ pkgs ? import <nixpkgs> { } }:

let
  runCmd = import ./commands/run.nix { inherit pkgs; };
  planCmd = import ./commands/plan.nix { inherit pkgs; };
  invokeCmd = import ./commands/invoke.nix { inherit pkgs; };
  composeCmd = import ./commands/compose.nix { inherit pkgs; };
in
pkgs.writeShellScriptBin "a-layer" ''
  #!${pkgs.bash}/bin/bash
  set -euo pipefail

  COMMAND="''${1:-help}"
  shift || true

  case "$COMMAND" in
    run)
      exec ${runCmd}/bin/a-layer-run "$@"
      ;;
    plan)
      exec ${planCmd}/bin/a-layer-plan "$@"
      ;;
    invoke)
      exec ${invokeCmd}/bin/a-layer-invoke "$@"
      ;;
    compose)
      exec ${composeCmd}/bin/a-layer-compose "$@"
      ;;
    help|--help|-h)
      cat <<EOF
A-Layer: Nix+Nickel Agent Orchestration

USAGE:
    a-layer <COMMAND> [OPTIONS]

COMMANDS:
    run <spec> --input <text>    Execute an agent or workflow
    plan <spec>                  Show execution plan without running
    invoke <agent.skill> --input <text>  Invoke specific skill
    compose                      Interactive workflow builder

OPTIONS:
    -h, --help                   Show this help message
    --version                    Show version information

EXAMPLES:
    a-layer run examples/simple-agent.ncl --input "Hello"
    a-layer plan examples/workflow.ncl
    a-layer invoke my-agent.research --input "quantum computing"

For more information, see: https://github.com/lessuseless-systems/dot-ai
EOF
      ;;
    --version)
      echo "a-layer 0.1.0"
      ;;
    *)
      echo "Unknown command: $COMMAND" >&2
      echo "Run 'a-layer help' for usage information" >&2
      exit 1
      ;;
  esac
''
