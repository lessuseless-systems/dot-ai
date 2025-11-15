# Core orchestration logic
# Generates execution DAG from workflow specification

let Workflow = import "../types/Workflow.ncl" in
let Context = import "../types/Context.ncl" in
let dag = import "./dag.ncl" in

{
  # Generate execution DAG from workflow
  buildDAG | Workflow -> Dyn = fun workflow =>
    let
      nodes = workflow.steps
        |> std.array.map (fun step => {
          id = step.agent,
          type = "agent",
          input = step.input,
          parallel = step.output_to |> std.option.unwrap_or false,
        })
    in
    dag.create nodes,

  # Validate workflow structure
  validate | Workflow -> Bool = fun workflow =>
    let has_steps = std.array.length workflow.steps > 0 in
    let valid_agents = workflow.steps
      |> std.array.all (fun step => std.string.length step.agent > 0)
    in
    has_steps && valid_agents,

  # Analyze workflow dependencies
  analyzeDependencies | Workflow -> Array {from | String, to | String} = fun workflow =>
    workflow.steps
      |> std.array.fold_left
        (fun acc step =>
          if std.record.has_field "output_to" step then
            acc @ [{from = step.agent, to = step.output_to}]
          else
            acc
        )
        [],
}
