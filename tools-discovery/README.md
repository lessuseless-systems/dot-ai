# Tools Discovery Environment

**Purpose:** Isolated testing environment to discover configuration files and patterns for each AI tool.

## Structure

Each tool gets its own subdirectory:
```
tools-discovery/
├── README.md              # This file
├── discover.nu            # Nushell discovery script
├── DISCOVERIES.md         # Findings log
├── amp/                   # Run Amp from here
├── gemini-cli/            # Run Gemini CLI from here
├── crush/                 # Run Crush from here
└── ...                    # One directory per tool
```

## Discovery Methodology

### 1. Run Tool in Isolated Directory
```bash
cd tools-discovery/<tool-name>/
nix run github:numtide/nix-ai-tools#<tool-name> -- --help
```

### 2. Capture What Files Get Created
- Check for dotfiles in current directory (`.tool-name/`)
- Check home directory for global configs (`~/.tool-name/`, `~/.config/tool-name/`)
- Note any XDG paths used
- Document config file formats

### 3. Document Findings
Update `DISCOVERIES.md` with:
- Config file locations (global + project)
- File formats (JSON, TOML, YAML)
- Config structure/schema
- MCP server configuration patterns
- Permissions/security patterns
- Default values

## Priority Tools (from TOOL-CONFIG-MATRIX.md Tier 1)

### Tier 1 - Immediate Priority
1. **cursor-agent** - CLI tool for Cursor
2. **gemini-cli** - Well-documented, clear precedence model
3. **claude-code** - Anthropic's CLI agent
4. **amp** - Comprehensive settings.json example

### Tier 2 - High Priority
5. **crush** - Clean priority hierarchy, XDG compliant
6. **codex** - TOML format (need parser)
7. **goose-cli** - Local extensible agent
8. **nanocoder** - Local-first approach

### Tier 3 - Research Interest
9. **forge** - AI-enhanced dev environment
10. **eca** - Editor-agnostic approach
11. **qwen-code** - Qwen model patterns
12. **droid** - Factory AI patterns
13. **groq-code-cli** - Groq-specific config

## Discovery Process

### Automated Discovery Script (discover.nu)
```bash
# Run discovery for a tool
./discover.nu <tool-name>

# Run discovery for all priority tools
./discover.nu --all

# Just check what would be discovered (dry-run)
./discover.nu <tool-name> --dry-run
```

### Manual Discovery Steps
1. **Pre-check**: Note current dotfiles/configs
   ```bash
   ls -la ~/
   ls -la ~/.config/
   ```

2. **Run tool**: Execute in isolated directory
   ```bash
   cd tools-discovery/<tool-name>/
   nix run github:numtide/nix-ai-tools#<tool-name> -- --help
   ```

3. **Post-check**: See what was created
   ```bash
   # Check local directory
   ls -la .

   # Check home directory
   ls -la ~/ | grep -E "(tool-name|\.tool)"
   ls -la ~/.config/ | grep tool

   # Check for hidden files
   find . -name ".*" -type f
   find . -name ".*" -type d
   ```

4. **Capture config**: If config files exist, copy them
   ```bash
   # Copy any created configs to discoveries/
   cp ~/.tool-name/config.json ./config.example.json
   cp ./.tool-name/settings.json ./settings.example.json
   ```

5. **Document**: Update DISCOVERIES.md

## What to Look For

### Configuration Files
- [ ] Global config location (Linux/macOS/Windows paths)
- [ ] Project dotfile directory (`.tool-name/`)
- [ ] Config file names and formats
- [ ] XDG compliance

### MCP Integration
- [ ] MCP server definitions location
- [ ] STDIO vs HTTP transport patterns
- [ ] Environment variable handling
- [ ] MCP config schema

### Security/Permissions
- [ ] Permission configuration location
- [ ] Access control patterns (allow/deny lists)
- [ ] Tool-specific security settings

### Agent Context
- [ ] Custom instruction file support (TOOL.md)
- [ ] Project context references
- [ ] Model configuration options

### Editor Integration
- [ ] Editor preference settings
- [ ] Formatter configuration
- [ ] Language tooling settings

## Environment Setup

### Clean Test Environment
```bash
# Create a temporary home for testing
export TEST_HOME=/tmp/lib-ai-test-home
mkdir -p $TEST_HOME
HOME=$TEST_HOME nix run github:numtide/nix-ai-tools#<tool-name>
```

### Capture All File Operations
```bash
# Use strace to see file access patterns (Linux)
strace -e trace=open,openat,creat -f nix run github:numtide/nix-ai-tools#<tool-name> 2>&1 | grep -E "(\.config|\.tool|settings|config)"

# Use fs_usage on macOS
sudo fs_usage -f filesys nix run github:numtide/nix-ai-tools#<tool-name>
```

## Expected Outputs

For each tool, we should discover:

1. **Global Configuration**
   - Path: `~/.tool-name/` or `~/.config/tool-name/`
   - Files: `config.json`, `settings.json`, etc.
   - Format: JSON, TOML, YAML

2. **Project Configuration**
   - Path: `./.tool-name/` or `./tool-name.json`
   - Files: Project-specific overrides
   - Format: Usually matches global format

3. **MCP Servers**
   - Location within config structure
   - Schema/format
   - Example definitions

4. **Permissions/Security**
   - Separate file or nested in main config
   - Schema/structure
   - Default policies

5. **Context/Instructions**
   - Markdown file support (TOOL.md)
   - Reference mechanism
   - File location patterns

## Safety Notes

- Tools may make network requests on first run
- Some tools may require API keys (set dummy values for testing)
- Some tools may attempt to modify files outside their directory
- Use isolated testing environment for unfree/proprietary tools
- Review generated configs before committing

## Contributing Discoveries

When you discover config patterns:
1. Document in `DISCOVERIES.md`
2. Save example configs in tool's subdirectory
3. Update `TOOL-CONFIG-MATRIX.md` with findings
4. Note any discrepancies with existing research
