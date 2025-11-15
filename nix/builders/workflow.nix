{ pkgs }:

let
  llmBuilder = import ./llm.nix { inherit pkgs; };
  dagBuilder = import ./dag.nix { inherit pkgs; };
in
{
  # Execute a workflow step
  executeStep = { step, context, agents }:
    pkgs.runCommand "workflow-step-${step.agent}" { } ''
      echo "[a-layer] Executing step: ${step.agent}" >&2

      AGENT="${step.agent}"
      INPUT="${builtins.toJSON step.input}"
      CONTEXT='${builtins.toJSON context}'

      # TODO: Look up agent and execute
      # For now, placeholder

      cat <<EOF > $out
{
  "step": "$AGENT",
  "input": $INPUT,
  "output": "Step executed (placeholder)",
  "timestamp": "$(date -Iseconds)"
}
EOF
    '';

  # Execute workflow sequentially
  executeSequential = { workflow, input, agents ? { } }:
    let
      steps = workflow.steps;

      # Execute steps in order, threading context
      executeSteps = stepIndex: prevContext:
        if stepIndex >= builtins.length steps then
          prevContext
        else
          let
            step = builtins.elemAt steps stepIndex;
            stepResult = executeStep {
              inherit step agents;
              context = prevContext;
            };
            newContext = prevContext // {
              previous = builtins.fromJSON (builtins.readFile stepResult);
              current_step = stepIndex + 1;
            };
          in
          executeSteps (stepIndex + 1) newContext;

      initialContext = {
        input = input;
        current_step = 0;
        total_steps = builtins.length steps;
        outputs = { };
      };

      finalContext = executeSteps 0 initialContext;
    in
    pkgs.writeText "workflow-result.json" (builtins.toJSON finalContext);

  # Execute workflow with parallel steps
  executeParallel = { workflow, input, agents ? { } }:
    let
      steps = workflow.steps;

      # Group steps by parallelism
      parallelGroups = builtins.foldl'
        (acc: step:
          if step.parallel or false then
            acc // { parallel = acc.parallel ++ [ step ]; }
          else
            acc // { sequential = acc.sequential ++ [ step ]; }
        )
        { parallel = [ ]; sequential = [ ]; }
        steps;

      # Execute parallel group
      parallelResults = builtins.map
        (step: executeStep {
          inherit step agents;
          context = { inherit input; };
        })
        parallelGroups.parallel;

      # Combine results
      combinedResult = pkgs.runCommand "parallel-results" { } ''
        ${pkgs.jq}/bin/jq -s '.' ${toString parallelResults} > $out
      '';
    in
    combinedResult;
}
