#!/usr/bin/env nu

# AI Tool Configuration Discovery Script
# Automatically discovers config files created by AI tools

# Main discovery function
def main [
    tool?: string              # Tool name (e.g., "gemini-cli")
    --all                      # Discover all priority tools
    --dry-run                  # Just show what would be done
    --clean                    # Clean tool directory before discovery
    --verbose                  # Show detailed output
] {
    if $all {
        discover_all_tools
    } else if ($tool != null) {
        discover_tool $tool --dry-run=$dry_run --clean=$clean --verbose=$verbose
    } else {
        print "Usage: discover.nu <tool-name> [--dry-run] [--clean] [--verbose]"
        print "   or: discover.nu --all"
        print ""
        print "Available tools:"
        list_tools
    }
}

# Discover configuration for a single tool
def discover_tool [
    tool: string
    --dry-run
    --clean
    --verbose
] {
    let tool_dir = $"($env.PWD)/($tool)"

    print $"🔍 Discovering configuration for: ($tool)"
    print $"📁 Tool directory: ($tool_dir)"
    print ""

    if $dry_run {
        print "🏃 DRY RUN - No changes will be made"
        print ""
    }

    # Create tool directory
    if not ($tool_dir | path exists) {
        if $dry_run {
            print $"Would create directory: ($tool_dir)"
        } else {
            mkdir $tool_dir
            print $"✅ Created directory: ($tool_dir)"
        }
    }

    # Clean if requested
    if $clean and not $dry_run {
        print "🧹 Cleaning tool directory..."
        rm -rf $tool_dir
        mkdir $tool_dir
    }

    # Capture state before running tool
    print "📸 Capturing pre-run state..."
    let before = capture_state

    if $dry_run {
        print $"Would run: nix run github:numtide/nix-ai-tools#($tool) -- --help"
        return
    }

    # Run tool
    print $"🚀 Running: nix run github:numtide/nix-ai-tools#($tool) -- --help"
    print ""

    try {
        cd $tool_dir
        let result = (do {
            nix run $"github:numtide/nix-ai-tools#($tool)" -- --help
        } | complete)

        if $result.exit_code == 0 {
            print "✅ Tool executed successfully"
            if $verbose {
                print $result.stdout
            }
        } else {
            print $"⚠️  Tool exited with code ($result.exit_code)"
            if $verbose {
                print $result.stderr
            }
        }
    } catch {
        print $"❌ Failed to run tool: ($tool)"
        return
    }

    # Capture state after running tool
    print "📸 Capturing post-run state..."
    let after = capture_state

    # Analyze differences
    print ""
    print "📊 Analyzing discovered files..."
    analyze_differences $before $after $tool_dir $tool

    # Generate discovery report
    generate_report $tool $tool_dir
}

# Capture current filesystem state
def capture_state [] {
    {
        home_files: (ls -a $env.HOME | get name),
        config_files: (if ("~/.config" | path expand | path exists) {
            ls -a ~/.config | get name
        } else {
            []
        }),
        pwd_files: (ls -a | get name)
    }
}

# Analyze what changed
def analyze_differences [before: record, after: record, tool_dir: string, tool: string] {
    # Check home directory
    let new_home = ($after.home_files | where $it not-in $before.home_files)
    if ($new_home | length) > 0 {
        print $"🏠 New files in HOME:"
        $new_home | each { |f| print $"   - ($f)" }
    }

    # Check .config directory
    let new_config = ($after.config_files | where $it not-in $before.config_files)
    if ($new_config | length) > 0 {
        print $"⚙️  New files in ~/.config:"
        $new_config | each { |f| print $"   - ($f)" }
    }

    # Check tool directory
    print $"📂 Files in tool directory:"
    try {
        ls -a $tool_dir | each { |f|
            let rel_path = ($f.name | str replace $"($tool_dir)/" "")
            print $"   - ($rel_path)"
        }
    } catch {
        print "   (none)"
    }

    # Check for common config patterns
    check_common_patterns $tool
}

# Check for common configuration patterns
def check_common_patterns [tool: string] {
    print ""
    print "🔎 Checking common config patterns..."

    let patterns = [
        { path: $"~/.($tool)", desc: "Home dotfile" },
        { path: $"~/.config/($tool)", desc: "XDG config" },
        { path: $"~/.($tool)/config.json", desc: "JSON config" },
        { path: $"~/.($tool)/settings.json", desc: "Settings JSON" },
        { path: $"~/.($tool)/config.toml", desc: "TOML config" },
        { path: $"~/.config/($tool)/config.json", desc: "XDG JSON config" },
        { path: $"./($tool).json", desc: "Root config file" },
        { path: $"./.($tool)", desc: "Project dotfile dir" },
    ]

    $patterns | each { |p|
        let expanded = ($p.path | path expand)
        if ($expanded | path exists) {
            print $"   ✅ Found: ($p.desc) at ($p.path)"

            # Show file info
            let info = (ls $expanded)
            if ($info | length) > 0 {
                let size = ($info | get 0.size)
                print $"      Size: ($size)"

                # Try to detect format
                if ($expanded | path type) == "file" {
                    detect_format $expanded
                }
            }
        }
    }
}

# Detect file format
def detect_format [file: string] {
    let content = (try { open $file } catch { "" })

    if ($content | str starts-with "{") {
        print "      Format: JSON"
    } else if ($content | str contains "=") {
        print "      Format: TOML (likely)"
    } else if ($content | str contains ":") {
        print "      Format: YAML (likely)"
    } else if ($content | str starts-with "#") {
        print "      Format: Markdown or config with comments"
    }
}

# Generate discovery report
def generate_report [tool: string, tool_dir: string] {
    print ""
    print "📝 Generating discovery report..."

    let report_file = $"($tool_dir)/DISCOVERY-REPORT.md"
    let timestamp = (date now | format date "%Y-%m-%d %H:%M:%S")

    let report = $"# Discovery Report: ($tool)

**Generated:** ($timestamp)
**Nix Package:** github:numtide/nix-ai-tools#($tool)

## Files Discovered

### Global Configuration
<!-- Found in ~/.($tool) or ~/.config/($tool) -->

### Project Configuration
<!-- Found in ./($tool_dir) -->

## Next Steps
- [ ] Document config structure in DISCOVERIES.md
- [ ] Copy example configs
- [ ] Update TOOL-CONFIG-MATRIX.md with findings
- [ ] Test with actual usage (not just --help)

## Raw Notes
<!-- Add manual observations here -->
"

    $report | save -f $report_file
    print $"✅ Report saved to: ($report_file)"
}

# Discover all priority tools
def discover_all_tools [] {
    let priority_tools = [
        "gemini-cli",
        "claude-code",
        "cursor-agent",
        "amp",
        "crush",
        "codex",
        "goose-cli",
        "nanocoder"
    ]

    print $"🔍 Discovering ($priority_tools | length) priority tools..."
    print ""

    $priority_tools | each { |tool|
        print $"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        discover_tool $tool
        print ""
    }

    print "✅ All discoveries complete!"
    print "📊 Review DISCOVERIES.md and individual tool reports"
}

# List available tools
def list_tools [] {
    let tools = [
        { name: "gemini-cli", priority: "Tier 1", reason: "Well-documented precedence" },
        { name: "claude-code", priority: "Tier 1", reason: "Anthropic CLI agent" },
        { name: "cursor-agent", priority: "Tier 1", reason: "Cursor CLI tool" },
        { name: "amp", priority: "Tier 1", reason: "Comprehensive settings.json" },
        { name: "crush", priority: "Tier 2", reason: "XDG compliant" },
        { name: "codex", priority: "Tier 2", reason: "TOML format" },
        { name: "goose-cli", priority: "Tier 2", reason: "Local extensible" },
        { name: "nanocoder", priority: "Tier 2", reason: "Local-first" },
        { name: "forge", priority: "Tier 3", reason: "Dev environment" },
        { name: "eca", priority: "Tier 3", reason: "Editor-agnostic" },
        { name: "qwen-code", priority: "Tier 3", reason: "Qwen patterns" },
        { name: "droid", priority: "Tier 3", reason: "Factory AI" },
    ]

    print ($tools | table)
}

# Clean all tool directories
def "main clean-all" [] {
    print "🧹 Cleaning all tool directories..."

    ls | where type == dir | each { |dir|
        print $"   Removing: ($dir.name)"
        rm -rf $dir.name
    }

    print "✅ All tool directories cleaned"
}
