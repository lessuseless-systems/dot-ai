# Simple agent example
# Demonstrates basic agent configuration

let Agent = import "../types/Agent.ncl" in
let Skill = import "../types/Skill.ncl" in
let Tool = import "../types/Tool.ncl" in
let Router = import "../types/Router.ncl" in

{
  name = "simple-researcher",
  model = "claude-3-5-sonnet-20241022",

  skills = [
    {
      name = "search",
      entry = "search.query",
      description = "Search for information on a topic",
      config = {
        max_results = 10,
      },
    },
    {
      name = "summarize",
      entry = "text.summarize",
      description = "Summarize text content",
      config = {
        max_length = 500,
      },
    },
  ],

  tools = [
    {
      name = "web-fetch",
      kind = 'Http,
      entry = "https://api.example.com/fetch",
      config = {
        method = 'GET,
      },
    },
  ],

  router = {
    strategy = 'RoundRobin,
    max_depth = 3,
  },

  config = {
    temperature = 0.7,
    max_tokens = 2000,
  },
} | Agent
