# Multi-agent system example
# Demonstrates agent-to-agent communication

let Workflow = import "../types/Workflow.ncl" in
let Router = import "../types/Router.ncl" in

{
  name = "collaborative-analysis",

  steps = [
    {
      agent = "data-collector",
      input = "context.topic",
      output_to = "raw_data",
      retry = {
        max_attempts = 3,
        backoff = 'Exponential,
      },
    },
    {
      agent = "data-analyzer",
      input = "outputs.raw_data",
      output_to = "analysis",
    },
    {
      agent = "visualization-expert",
      input = "outputs.analysis",
      parallel = true,
      output_to = "charts",
    },
    {
      agent = "report-writer",
      input = "outputs.analysis",
      parallel = true,
      output_to = "report",
    },
    {
      agent = "final-reviewer",
      input = "{ charts: outputs.charts, report: outputs.report }",
      output_to = "reviewed_output",
    },
  ],

  router = {
    strategy = 'ClaudeCodeRouter,
    max_depth = 10,
    fallback_strategy = 'RoundRobin,
  },

  context = {
    topic = "AI agent orchestration systems",
    detail_level = "comprehensive",
  },
} | Workflow
