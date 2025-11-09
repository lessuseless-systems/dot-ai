# Tool Configuration Discoveries

**Purpose:** Document actual configuration patterns discovered by running tools in isolation.

**Last Updated:** 2025-11-07

---

## Discovery Log

### Template

```markdown
## <Tool Name>

**Discovery Date:** YYYY-MM-DD
**Nix Package:** github:numtide/nix-ai-tools#<package-name>
**Version:** X.Y.Z

### Global Configuration
- **Path (Linux):** `path/to/config`
- **Path (macOS):** `path/to/config`
- **Path (Windows):** `path\to\config`
- **Files:** `config.json`, `settings.toml`, etc.
- **Format:** JSON/TOML/YAML
- **XDG Compliant:** Yes/No

### Project Configuration
- **Dotfile Directory:** `.tool-name/`
- **Config Files:** `settings.json`, etc.
- **Format:** JSON/TOML/YAML
- **Created on First Run:** Yes/No

### MCP Support
- **MCP Configuration Location:** Path in config structure
- **Schema:** JSON schema or example
- **Transport Types:** STDIO, HTTP, both
- **Example:**
```json
{
  "mcpServers": {
    "example": {
      "command": "node",
      "args": ["path/to/server.js"],
      "env": {
        "API_KEY": "value"
      }
    }
  }
}
```

### Permissions/Security
- **Location:** Separate file or nested
- **Schema:** Allow/deny lists structure
- **Example:**
```json
{
  "permissions": {
    "execute_bash": ["git", "npm"],
    "fs_read": ["/path/to/allowed"]
  }
}
```

### Context/Instructions
- **Markdown Support:** Yes/No
- **File Name Convention:** `TOOL.md`
- **Reference Mechanism:** How config points to context files

### Additional Notes
- Quirks, gotchas, interesting behaviors
- Differences from documented behavior
- Missing features vs documentation

---
```

---

## Discoveries

<!-- Tools will be documented here as we discover their patterns -->

### Status Legend
- 🔍 **Not Started** - Tool not yet tested
- 🚧 **In Progress** - Currently investigating
- ✅ **Complete** - Full discovery documented
- ⚠️ **Partial** - Some info discovered, needs more investigation
- ❌ **Failed** - Tool couldn't be tested (error, missing deps, etc.)

---

## Priority Queue

### Tier 1 - Immediate Priority
- 🔍 **cursor-agent** - CLI tool for Cursor
- 🔍 **gemini-cli** - Well-documented precedence model
- 🔍 **claude-code** - Anthropic CLI agent
- 🔍 **amp** - Comprehensive settings.json

### Tier 2 - High Priority
- 🔍 **crush** - XDG compliant
- 🔍 **codex** - TOML format
- 🔍 **goose-cli** - Local extensible
- 🔍 **nanocoder** - Local-first

### Tier 3 - Research Interest
- 🔍 **forge** - Dev environment
- 🔍 **eca** - Editor-agnostic
- 🔍 **qwen-code** - Qwen patterns
- 🔍 **droid** - Factory AI
- 🔍 **groq-code-cli** - Groq-specific

---

## Cross-Tool Patterns

As we discover patterns, document commonalities here:

### Common Config Locations
- `~/.config/<tool>/` - XDG compliant tools
- `~/.tool-name/` - Traditional dotfile location
- `./.tool-name/` - Project-level configs

### Common Config Files
- `settings.json` - General settings
- `config.json` / `config.toml` - Main configuration
- `mcp.json` - MCP server definitions
- `permissions.json` - Access control
- `TOOL.md` - Context instructions

### Common MCP Patterns
- `mcpServers` object key
- STDIO: `command`, `args`, `env`
- HTTP: `url`, `headers`

### Common Permission Patterns
- `execute_bash`: Command allowlist
- `fs_read`: Path allowlist
- `fs_write`: Path allowlist
- `network`: Network access rules

---

## Discrepancies

Document cases where actual behavior differs from existing research:

### Tool Name
- **Expected:** What research document said
- **Actual:** What we discovered
- **Impact:** How this affects `.ai` design
- **Action:** Update TOOL-CONFIG-MATRIX.md

---

## Testing Notes

### Environment
- **OS:** Linux/macOS
- **Nix Version:** X.Y.Z
- **Test Date:** YYYY-MM-DD
- **Test User:** Name

### Issues Encountered
- Tool X failed to start (reason)
- Tool Y requires API key (workaround)
- Tool Z network access blocked

---

## Next Steps

After discovery phase:
1. [ ] Update TOOL-CONFIG-MATRIX.md with actual findings
2. [ ] Create Nickel schemas based on discovered patterns
3. [ ] Identify most common config structure for `.ai` defaults
4. [ ] Build proof-of-concept translator for most common pattern
5. [ ] Document exceptions/edge cases for translation layer
