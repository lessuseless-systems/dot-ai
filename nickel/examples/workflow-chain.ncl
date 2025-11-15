# Multi-step workflow example
# Demonstrates sequential and parallel execution

let Workflow = import "../types/Workflow.ncl" in
let Router = import "../types/Router.ncl" in

{
  name = "research-pipeline",

  steps = [
    {
      agent = "web-researcher",
      input = "context.query",
      output_to = "research_results",
    },
    {
      agent = "fact-checker-1",
      input = "previous.output",
      parallel = true,
      output_to = "fact_check_1",
    },
    {
      agent = "fact-checker-2",
      input = "previous.output",
      parallel = true,
      output_to = "fact_check_2",
    },
    {
      agent = "summarizer",
      input = "outputs.research_results",
      output_to = "final_summary",
    },
  ],

  router = {
    strategy = 'LoopErased,
    max_depth = 5,
  },

  context = {
    query = "What is loop-erased random walk?",
    max_iterations = 3,
  },
} | Workflow
