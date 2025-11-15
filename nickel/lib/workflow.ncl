# Workflow composition and manipulation

let Workflow = import "../types/Workflow.ncl" in
let Context = import "../types/Context.ncl" in

{
  # Compose multiple workflows sequentially
  composeSequential | Array Workflow -> Workflow = fun workflows =>
    let all_steps = workflows
      |> std.array.fold_left
        (fun acc wf => acc @ wf.steps)
        []
    in
    {
      name = "composed-workflow",
      steps = all_steps,
      router = (std.array.first workflows).router,
      context = {},
    },

  # Compose workflows in parallel
  composeParallel | Array Workflow -> Workflow = fun workflows =>
    let parallel_steps = workflows
      |> std.array.map (fun wf =>
        wf.steps
          |> std.array.map (fun step => step & {parallel = true})
      )
      |> std.array.flatten
    in
    {
      name = "parallel-workflow",
      steps = parallel_steps,
      router = (std.array.first workflows).router,
      context = {},
    },

  # Create a simple linear workflow
  linear | Array {agent | String, input | Dyn} -> Workflow = fun steps =>
    {
      name = "linear-workflow",
      steps = steps,
      router = {strategy = 'RoundRobin},
      context = {},
    },

  # Add context to workflow
  withContext | Workflow -> {..} -> Workflow = fun workflow => fun ctx =>
    workflow & {context = ctx},

  # Map over workflow steps
  mapSteps | Workflow -> (Dyn -> Dyn) -> Workflow = fun workflow => fun f =>
    workflow & {steps = workflow.steps |> std.array.map f},
}
