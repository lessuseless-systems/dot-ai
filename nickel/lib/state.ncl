# State management for workflow execution

let Context = import "../types/Context.ncl" in
let Workflow = import "../types/Workflow.ncl" in

{
  # Initialize context for workflow
  initContext | Workflow -> String -> Context = fun workflow => fun input => {
    current_step = 0,
    total_steps = std.array.length workflow.steps,
    input = input,
    outputs = {},
    previous = null,
    state = workflow.context,
    metadata = {
      workflow_id = "wf-%{std.random.integer 0 999999 |> std.to_string}",
      started_at = "2025-11-15T00:00:00Z",  # Would use actual timestamp
      updated_at = "2025-11-15T00:00:00Z",
    },
  },

  # Update context after step execution
  updateContext | Context -> {step_index | Number, output | Dyn, agent | String}
    -> Context = fun ctx => fun result =>
    ctx & {
      current_step = result.step_index + 1,
      outputs = ctx.outputs & {"%{result.agent}" = result.output},
      previous = {
        output = result.output,
        agent = result.agent,
        step_index = result.step_index,
      },
      metadata = ctx.metadata & {
        updated_at = "2025-11-15T00:00:00Z",  # Would use actual timestamp
      },
    },

  # Get value from context
  getValue | Context -> String -> Dyn = fun ctx => fun key =>
    if std.record.has_field key ctx.outputs then
      ctx.outputs."%{key}"
    else if std.record.has_field key ctx.state then
      ctx.state."%{key}"
    else
      null,

  # Check if workflow is complete
  isComplete | Context -> Bool = fun ctx =>
    ctx.current_step >= ctx.total_steps,

  # Merge contexts (for parallel execution)
  mergeContexts | Array Context -> Context = fun contexts =>
    let base = std.array.first contexts in
    contexts
      |> std.array.fold_left
        (fun acc ctx => acc & {
          outputs = acc.outputs & ctx.outputs,
        })
        base,
}
