{ pkgs, nickelPkg }:

let
  agentBuilder = import ./agent-builder.nix { inherit pkgs nickelPkg; };
  workflowBuilder = import ./workflow-builder.nix { inherit pkgs nickelPkg; };
  runtime = import ./runtime.nix { inherit pkgs nickelPkg; };
in
{
  # Re-export all library functions
  inherit (agentBuilder) buildAgent;
  inherit (workflowBuilder) buildWorkflow composeWorkflows;
  inherit (runtime) execute executeAsync plan;

  # Utility functions
  utils = {
    # Evaluate Nickel file and return JSON
    evalNickel = nickelFile:
      pkgs.runCommand "eval-nickel" { } ''
        ${nickelPkg}/bin/nickel export --format json ${nickelFile} > $out
      '';

    # Validate Nickel spec against schema
    validateSpec = spec: schema:
      pkgs.runCommand "validate-nickel" { } ''
        ${nickelPkg}/bin/nickel typecheck ${spec}
        touch $out
      '';
  };
}
