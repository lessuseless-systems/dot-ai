{ pkgs, nickelPkg }:

let
  agentBuilder = import ./agent-builder.nix { inherit pkgs nickelPkg; };
  workflowBuilder = import ./workflow-builder.nix { inherit pkgs nickelPkg; };
in
{
  # Execute an agent or workflow synchronously
  execute = entity: input:
    if entity ? execute then
      entity.execute input
    else
      throw "Entity does not have an execute method";

  # Execute asynchronously (returns derivation)
  executeAsync = entity: input:
    pkgs.runCommand "a-layer-execution" { } ''
      RESULT=$(${entity.executor}/bin/* "${input}")
      echo "$RESULT" > $out
    '';

  # Generate execution plan without running
  plan = entity:
    let
      config = entity.config or { };
      planOutput = pkgs.writeText "execution-plan.json" (builtins.toJSON {
        name = entity.name or "unknown";
        type = if config ? steps then "workflow" else "agent";
        config = config;
      });
    in
    planOutput;

  # Utility: Collect results from multiple executions
  collect = results:
    pkgs.runCommand "collect-results" { } ''
      ${pkgs.jq}/bin/jq -s '.' ${toString results} > $out
    '';
}
