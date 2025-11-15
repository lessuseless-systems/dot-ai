{ pkgs }:

pkgs.writeShellScriptBin "a-layer-compose" ''
  #!${pkgs.bash}/bin/bash
  set -euo pipefail

  echo "A-Layer Interactive Workflow Composer"
  echo "======================================"
  echo ""
  echo "This feature is not yet implemented."
  echo ""
  echo "Future capabilities:"
  echo "  - Interactive workflow building"
  echo "  - Agent selection"
  echo "  - Step configuration"
  echo "  - Router selection"
  echo "  - Export to Nickel spec"
  echo ""
  echo "For now, please write Nickel specs manually."
  echo "See examples/ directory for reference."
''
