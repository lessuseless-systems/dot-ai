# Prompt Caching - Claude Documentation

## Overview

Prompt caching is a feature that optimizes API usage by allowing you to reuse prefixes from previous prompts, significantly reducing processing time and costs for repetitive tasks.

## How Prompt Caching Works

When you send a request with caching enabled:

1. The system checks if a prompt prefix up to a cache breakpoint is already cached from a recent query
2. If found, it uses the cached version, reducing processing time and costs
3. Otherwise, it processes the full prompt and caches the prefix once the response begins

**Key characteristics:**
- Default cache lifetime: 5 minutes (refreshed at no additional cost when used)
- Optional 1-hour cache available at additional cost
- "Prompt caching caches the full prefix" - tools, system, and messages up to the designated block

### Ideal Use Cases

Prompt caching works best for:
- Prompts with many examples
- Large amounts of context or background information
- Repetitive tasks with consistent instructions
- Long multi-turn conversations

## Pricing Structure

Cache operations introduce tiered pricing:

| Cost Type | Multiplier |
|-----------|-----------|
| 5-minute cache writes | 1.25x base input tokens |
| 1-hour cache writes | 2x base input tokens |
| Cache reads | 0.1x base input tokens |

**Example pricing (Claude Sonnet 4.5):**
- Base input: $3/MTok
- Cache write (5m): $3.75/MTok
- Cache hit: $0.30/MTok

## Implementation

### Supported Models

- Claude Opus 4.1
- Claude Opus 4
- Claude Sonnet 4.5
- Claude Sonnet 4
- Claude Sonnet 3.7
- Claude Haiku 4.5
- Claude Haiku 3.5
- Claude Haiku 3
- Claude Opus 3 (deprecated)

### Basic Structure

Mark static content with `cache_control` parameter:

```json
{
  "model": "claude-sonnet-4-5",
  "max_tokens": 1024,
  "system": [
    {
      "type": "text",
      "text": "Your instructions here"
    },
    {
      "type": "text",
      "text": "<large context or document>",
      "cache_control": {"type": "ephemeral"}
    }
  ],
  "messages": [
    {
      "role": "user",
      "content": "Your question here"
    }
  ]
}
```

### Cache Breakpoints

You can define up to 4 cache breakpoints to:
- Cache different sections that change at different frequencies
- Have explicit control over what gets cached
- Ensure caching for content more than 20 blocks before the final breakpoint
- Place breakpoints before editable content to guarantee cache hits

**Important:** The system uses a 20-block lookback window—it checks up to 20 blocks before each explicit breakpoint. For prompts with more than 20 blocks, set additional breakpoints.

## What Can Be Cached

- Tool definitions in the `tools` array
- System messages in the `system` array
- Text messages in `messages.content` (user and assistant turns)
- Images and documents in `messages.content` (user turns)
- Tool use and tool results in `messages.content` (both turns)

## What Cannot Be Cached

- Thinking blocks cannot be explicitly marked with `cache_control`, though they cache automatically when appearing in previous assistant turns
- Sub-content blocks like citations themselves (cache the top-level document instead)
- Empty text blocks

## Minimum Token Requirements

Cache requires minimum prompt lengths:
- Claude Opus 4.1, Sonnet 4.5, Sonnet 4, Sonnet 3.7: 1,024 tokens
- Claude Haiku 4.5: 4,096 tokens
- Claude Haiku 3.5, Haiku 3: 2,048 tokens

Prompts below these thresholds process without caching.

## Cache Invalidation

Changes that invalidate cache (organized by impact scope):

**Complete invalidation:**
- Modifying tool definitions

**System and message cache invalidation:**
- Enabling/disabling web search
- Enabling/disabling citations

**Message cache only:**
- Changes to `tool_choice` parameter
- Adding/removing images
- Changing extended thinking settings

## Tracking Cache Performance

Monitor these fields in the API response `usage` object:

- `cache_creation_input_tokens`: Tokens written to cache
- `cache_read_input_tokens`: Tokens retrieved from cache
- `input_tokens`: Tokens after the last cache breakpoint (not cached)

**Total calculation:**
```
total_input_tokens = cache_read_input_tokens + cache_creation_input_tokens + input_tokens
```

## Extended Thinking with Caching

Thinking blocks have special behavior:
- They cache automatically alongside other content in subsequent requests
- They count as input tokens when read from cache
- Cache invalidates when non-tool-result user content is added

## 1-Hour Cache Duration

For longer cache retention, specify TTL in cache control:

```json
"cache_control": {
  "type": "ephemeral",
  "ttl": "5m" | "1h"
}
```

Use 1-hour cache when:
- Prompts are used less frequently than 5 minutes but more than hourly
- Latency optimization is critical
- Rate limit utilization needs improvement

### Mixing TTLs

When combining different TTL values, 1-hour entries must appear before 5-minute entries. The system identifies three billing positions and charges accordingly for each segment.

## Best Practices

- Cache stable, reusable content at the prompt's beginning
- Use cache breakpoints strategically to separate different sections
- Set breakpoints at conversation ends and before editable content
- For prompts with 20+ blocks, add multiple breakpoints to ensure hits
- Regularly analyze cache hit rates and adjust strategy

## Common Issues & Solutions

**Cache not working:**
- Verify cached sections are identical and marked the same way
- Confirm calls occur within cache lifetime
- Check that `tool_choice` and images remain consistent
- Ensure minimum token requirements are met
- Validate stable JSON key ordering (some languages randomize this)

**Cache invalidation unexpected:**
- Review what invalidates cache for your use case
- Non-tool-result user content strips thinking blocks from context

## Cost Efficiency Tips

- "Cache breakpoints themselves don't add any cost"—pay only for actual cache writes and reads
- Place variable content after the final cache breakpoint
- Use 5-minute cache for frequent reuse (within 5 minutes)
- Use 1-hour cache for occasional reuse or longer processing times

## FAQ Highlights

**Do I need multiple breakpoints?**
A single breakpoint at the end of static content usually suffices; the system automatically checks previous blocks (up to 20) for hits.

**How do I calculate total input tokens?**
Add the three usage fields: cache reads + cache writes + regular input tokens.

**Can I use caching with Batches API?**
Yes, but cache hits are best-effort due to asynchronous processing. The 1-hour cache improves hit rates.

**Caching with Batches:**
Send an initial request with shared prefix and 1-hour cache, then submit remaining requests once complete.
