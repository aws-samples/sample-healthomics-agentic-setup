#!/usr/bin/env bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(cd "${1:-.}" 2>/dev/null && pwd)" || { echo "Error: Invalid target directory '${1:-}'"; exit 1; }

echo "╔══════════════════════════════════════════════════╗"
echo "║   AWS HealthOmics Agentic Tool Setup            ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Check for uvx
if ! command -v uvx &> /dev/null; then
    echo "⚠️  'uvx' not found. Install uv first:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Which agentic tool do you use?"
echo ""
echo "  1) Kiro IDE (Power)"
echo "  2) Kiro CLI"
echo "  3) Claude Code"
echo "  4) Cursor"
echo "  5) GitHub Copilot (VS Code)"
echo "  6) Cline"
echo "  7) Roo Code"
echo "  8) Windsurf"
echo "  9) OpenAI Codex CLI"
echo " 10) Google Gemini CLI"
echo ""
read -p "Enter choice (1-10): " choice

case $choice in
    1)
        TOOL="kiro-ide"
        echo ""
        echo "For Kiro IDE, install the power from the Kiro Power Store or copy the"
        echo "power directory into your project's .kiro/powers/ directory."
        echo ""
        echo "See: https://github.com/awslabs/mcp/tree/main/src/aws-healthomics-mcp-server"
        exit 0
        ;;
    2)
        TOOL="kiro-cli"
        SOURCE_DIR="$SCRIPT_DIR/kiro-cli"
        echo ""
        echo "Install scope:"
        echo "  g) Global  – available in all projects (~/.kiro/)"
        echo "  l) Local   – project-specific (.kiro/ in target dir)"
        echo ""
        read -p "Global or local? (g/L): " scope
        if [[ "$scope" =~ ^[Gg]$ ]]; then
            KIRO_GLOBAL=true
        else
            KIRO_GLOBAL=false
            FILES=()
            DIRS=(".kiro" "steering")
        fi
        ;;
    3)
        TOOL="claude-code"
        SOURCE_DIR="$SCRIPT_DIR/claude-code"
        echo ""
        echo "Install scope:"
        echo "  g) Global  – available in all projects (~/.claude/)"
        echo "  l) Local   – project-specific (target dir)"
        echo ""
        read -p "Global or local? (g/L): " scope
        if [[ "$scope" =~ ^[Gg]$ ]]; then
            CLAUDE_GLOBAL=true
        else
            CLAUDE_GLOBAL=false
            FILES=(".mcp.json")
            DIRS=(".claude")
        fi
        ;;
    4)
        TOOL="cursor"
        SOURCE_DIR="$SCRIPT_DIR/cursor"
        echo ""
        echo "Install scope:"
        echo "  g) Global  – available in all projects (~/.cursor/)"
        echo "  l) Local   – project-specific (.cursor/ in target dir)"
        echo ""
        read -p "Global or local? (g/L): " scope
        if [[ "$scope" =~ ^[Gg]$ ]]; then
            CURSOR_GLOBAL=true
        else
            CURSOR_GLOBAL=false
            FILES=()
            DIRS=(".cursor" "steering")
        fi
        ;;
    5)
        TOOL="copilot"
        SOURCE_DIR="$SCRIPT_DIR/copilot"
        FILES=()
        DIRS=(".vscode" ".github" "steering")
        ;;
    6)
        TOOL="cline"
        SOURCE_DIR="$SCRIPT_DIR/cline"
        FILES=("cline_mcp_settings.json")
        DIRS=(".clinerules" "steering")
        ;;
    7)
        TOOL="roo-code"
        SOURCE_DIR="$SCRIPT_DIR/roo-code"
        FILES=()
        DIRS=(".roo" "steering")
        ;;
    8)
        TOOL="windsurf"
        SOURCE_DIR="$SCRIPT_DIR/windsurf"
        FILES=("mcp_config.json")
        DIRS=(".windsurf" "steering")
        ;;
    9)
        TOOL="codex"
        SOURCE_DIR="$SCRIPT_DIR/codex"
        echo ""
        echo "Install scope:"
        echo "  g) Global  – available in all projects (~/.codex/)"
        echo "  l) Local   – project-specific (target dir)"
        echo ""
        read -p "Global or local? (g/L): " scope
        if [[ "$scope" =~ ^[Gg]$ ]]; then
            CODEX_GLOBAL=true
        else
            CODEX_GLOBAL=false
            FILES=("AGENTS.md" "config.toml")
            DIR_COPY="steering"
        fi
        ;;
    10)
        TOOL="gemini-cli"
        SOURCE_DIR="$SCRIPT_DIR/gemini"
        echo ""
        echo "Install scope:"
        echo "  g) Global  – available in all projects (~/.gemini/)"
        echo "  l) Local   – project-specific (.gemini/ in target dir)"
        echo ""
        read -p "Global or local? (g/L): " scope
        if [[ "$scope" =~ ^[Gg]$ ]]; then
            GEMINI_GLOBAL=true
        else
            GEMINI_GLOBAL=false
            FILES=()
            DIRS=(".gemini" "steering")
        fi
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo ""
echo "Installing HealthOmics configuration for: $TOOL"

# Kiro CLI global install
if [[ "${KIRO_GLOBAL:-false}" == "true" ]]; then
    KIRO_HOME="${HOME}/.kiro"
    echo "Target: $KIRO_HOME (global)"
    echo ""

    # Agent JSON + prompt
    mkdir -p "$KIRO_HOME/agents"
    dest="$KIRO_HOME/agents/healthomics.json"
    prompt_dest="$KIRO_HOME/agents/healthomics-prompt.md"
    if [[ -f "$dest" ]]; then
        read -p "  healthomics.json already exists. Overwrite? (y/N) " -n 1 -r
        echo ""
        [[ ! $REPLY =~ ^[Yy]$ ]] && echo "  Skipped agent" || {
            cp "$SOURCE_DIR/.kiro/agents/healthomics.json" "$dest"
            cp "$SOURCE_DIR/.kiro/agents/healthomics-prompt.md" "$prompt_dest"
            # Fix prompt path for global context
            sed 's|file://.kiro/agents/healthomics-prompt.md|file://healthomics-prompt.md|' "$dest" > "$dest.tmp" && mv "$dest.tmp" "$dest"
            echo "  ✓ Installed agent → agents/healthomics.json"
        }
    else
        cp "$SOURCE_DIR/.kiro/agents/healthomics.json" "$dest"
        cp "$SOURCE_DIR/.kiro/agents/healthomics-prompt.md" "$prompt_dest"
        sed 's|file://.kiro/agents/healthomics-prompt.md|file://healthomics-prompt.md|' "$dest" > "$dest.tmp" && mv "$dest.tmp" "$dest"
        echo "  ✓ Installed agent → agents/healthomics.json"
    fi

    # Steering files
    mkdir -p "$KIRO_HOME/steering"
    for f in "$SOURCE_DIR/steering/"*.md; do
        fname="$(basename "$f")"
        dest="$KIRO_HOME/steering/$fname"
        if [[ -f "$dest" ]]; then
            read -p "  $fname already exists. Overwrite? (y/N) " -n 1 -r
            echo ""
            [[ ! $REPLY =~ ^[Yy]$ ]] && { echo "  Skipped $fname"; continue; }
        fi
        cp "$f" "$dest"
        echo "  ✓ Installed steering/$fname"
    done

    echo ""
    echo "✅ Global setup complete!"
    echo ""
    echo "Activate the agent with: /agent healthomics"
    echo "Or press Ctrl+Shift+H in a chat session."
    exit 0
fi

# Claude Code global install
if [[ "${CLAUDE_GLOBAL:-false}" == "true" ]]; then
    CLAUDE_HOME="${HOME}/.claude"
    echo "Target: $CLAUDE_HOME (global)"
    echo ""

    mkdir -p "$CLAUDE_HOME"

    # .mcp.json (merge mcpServers key)
    dest="$CLAUDE_HOME/.mcp.json"
    if [[ -f "$dest" ]]; then
        if command -v jq &> /dev/null; then
            jq -s '.[0] * {mcpServers: (.[0].mcpServers + .[1].mcpServers)}' "$dest" "$SOURCE_DIR/.mcp.json" > "$dest.tmp"
            mv "$dest.tmp" "$dest"
            echo "  ✓ Merged MCP server into existing .mcp.json"
        else
            echo "  ⚠️  jq not found — manually merge $SOURCE_DIR/.mcp.json into $dest"
        fi
    else
        cp "$SOURCE_DIR/.mcp.json" "$dest"
        echo "  ✓ Installed .mcp.json"
    fi

    # Skill
    SKILL_DIR="$CLAUDE_HOME/skills/healthomics"
    mkdir -p "$SKILL_DIR/steering"
    cp "$SOURCE_DIR/.claude/skills/healthomics/SKILL.md" "$SKILL_DIR/SKILL.md"
    cp "$SOURCE_DIR/.claude/skills/healthomics/steering/"*.md "$SKILL_DIR/steering/"
    echo "  ✓ Installed skill → skills/healthomics/"

    echo ""
    echo "✅ Global setup complete!"
    echo ""
    echo "The HealthOmics MCP server and skill are now available in all projects."
    echo "Use '/healthomics' to load the skill in a conversation."
    exit 0
fi

# Cursor global install
if [[ "${CURSOR_GLOBAL:-false}" == "true" ]]; then
    CURSOR_HOME="${HOME}/.cursor"
    echo "Target: $CURSOR_HOME (global)"
    echo ""

    # Rules
    mkdir -p "$CURSOR_HOME/rules"
    dest="$CURSOR_HOME/rules/healthomics.mdc"
    if [[ -f "$dest" ]]; then
        read -p "  healthomics.mdc already exists. Overwrite? (y/N) " -n 1 -r
        echo ""
        [[ ! $REPLY =~ ^[Yy]$ ]] && echo "  Skipped rule" || {
            cp "$SOURCE_DIR/.cursor/rules/healthomics.mdc" "$dest"
            echo "  ✓ Installed rules/healthomics.mdc"
        }
    else
        cp "$SOURCE_DIR/.cursor/rules/healthomics.mdc" "$dest"
        echo "  ✓ Installed rules/healthomics.mdc"
    fi

    # MCP config
    dest="$CURSOR_HOME/mcp.json"
    if [[ -f "$dest" ]]; then
        if command -v jq &> /dev/null; then
            jq -s '.[0] * {mcpServers: (.[0].mcpServers + .[1].mcpServers)}' "$dest" "$SOURCE_DIR/.cursor/mcp.json" > "$dest.tmp"
            mv "$dest.tmp" "$dest"
            echo "  ✓ Merged MCP server into existing mcp.json"
        else
            echo "  ⚠️  jq not found — manually merge $SOURCE_DIR/.cursor/mcp.json into $dest"
        fi
    else
        cp "$SOURCE_DIR/.cursor/mcp.json" "$dest"
        echo "  ✓ Installed mcp.json"
    fi

    # Steering files
    mkdir -p "$CURSOR_HOME/steering"
    for f in "$SOURCE_DIR/steering/"*.md; do
        fname="$(basename "$f")"
        cp "$f" "$CURSOR_HOME/steering/$fname"
    done
    echo "  ✓ Installed steering/ files"

    echo ""
    echo "✅ Global setup complete!"
    exit 0
fi

# Codex global install
if [[ "${CODEX_GLOBAL:-false}" == "true" ]]; then
    CODEX_HOME="${HOME}/.codex"
    echo "Target: $CODEX_HOME (global)"
    echo ""

    # MCP server config
    mkdir -p "$CODEX_HOME"
    dest="$CODEX_HOME/config.toml"
    if [[ -f "$dest" ]]; then
        if grep -q "aws-healthomics" "$dest"; then
            echo "  ⚠️  aws-healthomics already in config.toml — skipped"
        else
            echo "" >> "$dest"
            cat "$SOURCE_DIR/config.toml" >> "$dest"
            echo "  ✓ Appended MCP server to config.toml"
        fi
    else
        cp "$SOURCE_DIR/config.toml" "$dest"
        echo "  ✓ Created config.toml with MCP server"
    fi

    # AGENTS.md
    dest="$CODEX_HOME/AGENTS.md"
    if [[ -f "$dest" ]]; then
        read -p "  AGENTS.md already exists. Append? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> "$dest"
            cat "$SOURCE_DIR/AGENTS.md" >> "$dest"
            echo "  ✓ Appended to AGENTS.md"
        else
            echo "  Skipped AGENTS.md"
        fi
    else
        cp "$SOURCE_DIR/AGENTS.md" "$dest"
        echo "  ✓ Installed AGENTS.md"
    fi

    # Skill
    SKILL_DIR="$CODEX_HOME/skills/aws-healthomics"
    mkdir -p "$SKILL_DIR/references"
    cp "$SOURCE_DIR/skill/SKILL.md" "$SKILL_DIR/SKILL.md"
    cp "$SOURCE_DIR/skill/references/"*.md "$SKILL_DIR/references/"
    echo "  ✓ Installed skill → skills/aws-healthomics/"

    echo ""
    echo "✅ Global setup complete!"
    echo ""
    echo "The HealthOmics MCP server and skill are now available in all projects."
    echo "Use '/use aws-healthomics' to load the skill, or it triggers automatically."
    exit 0
fi

# Gemini CLI global install
if [[ "${GEMINI_GLOBAL:-false}" == "true" ]]; then
    GEMINI_HOME="${HOME}/.gemini"
    echo "Target: $GEMINI_HOME (global)"
    echo ""

    mkdir -p "$GEMINI_HOME"

    # MCP server in settings.json
    dest="$GEMINI_HOME/settings.json"
    if [[ -f "$dest" ]]; then
        if command -v jq &> /dev/null; then
            if jq -e '.mcpServers["aws-healthomics"]' "$dest" &>/dev/null; then
                echo "  ⚠️  aws-healthomics already in settings.json — skipped"
            else
                jq -s '.[0] * {mcpServers: ((.[0].mcpServers // {}) + .[1].mcpServers)}' "$dest" "$SOURCE_DIR/settings.json" > "$dest.tmp"
                mv "$dest.tmp" "$dest"
                echo "  ✓ Merged MCP server into settings.json"
            fi
        else
            echo "  ⚠️  jq not found — manually merge $SOURCE_DIR/settings.json into $dest"
        fi
    else
        cp "$SOURCE_DIR/settings.json" "$dest"
        echo "  ✓ Created settings.json with MCP server"
    fi

    # GEMINI.md
    dest="$GEMINI_HOME/GEMINI.md"
    if [[ -f "$dest" ]]; then
        read -p "  GEMINI.md already exists. Append? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> "$dest"
            cat "$SOURCE_DIR/GEMINI.md" >> "$dest"
            echo "  ✓ Appended to GEMINI.md"
        else
            echo "  Skipped GEMINI.md"
        fi
    else
        cp "$SOURCE_DIR/GEMINI.md" "$dest"
        echo "  ✓ Installed GEMINI.md"
    fi

    # Steering files
    mkdir -p "$GEMINI_HOME/steering"
    for f in "$SOURCE_DIR/steering/"*.md; do
        fname="$(basename "$f")"
        cp "$f" "$GEMINI_HOME/steering/$fname"
    done
    echo "  ✓ Installed steering/ files"

    echo ""
    echo "✅ Global setup complete!"
    echo ""
    echo "The HealthOmics MCP server is now available in all projects."
    echo "Steering files are at ~/.gemini/steering/ — referenced from GEMINI.md."
    exit 0
fi

echo "Target directory: $(cd "$TARGET_DIR" && pwd)"
echo ""

# Copy files
if [[ ${#FILES[@]:-0} -gt 0 ]]; then
    for file in "${FILES[@]}"; do
        dest="$TARGET_DIR/$file"
        if [[ -f "$dest" ]]; then
            read -p "  $file already exists. Overwrite? (y/N) " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "  Skipped $file"
                continue
            fi
        fi
        cp "$SOURCE_DIR/$file" "$dest"
        echo "  ✓ Copied $file"
    done
fi

# Copy directories
if [[ -n "${DIRS:-}" ]]; then
    for dir in "${DIRS[@]}"; do
        dest="$TARGET_DIR/$dir"
        mkdir -p "$dest"
        cp -r "$SOURCE_DIR/$dir/"* "$dest/" 2>/dev/null || cp -r "$SOURCE_DIR/$dir/".* "$dest/" 2>/dev/null || true
        echo "  ✓ Copied $dir/"
    done
elif [[ -n "${DIR_COPY:-}" ]]; then
    dest="$TARGET_DIR/$DIR_COPY"
    mkdir -p "$dest"
    cp -r "$SOURCE_DIR/$DIR_COPY/"* "$dest/"
    echo "  ✓ Copied $DIR_COPY/"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Ensure you have valid AWS credentials configured"
echo "  2. Create .healthomics/config.toml with your settings:"
echo ""
echo "     omics_iam_role = \"arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>\""
echo "     run_output_uri = \"s3://<BUCKET>/healthomics-outputs/\""
echo "     run_storage_type = \"DYNAMIC\""
echo ""
echo "  3. Open your project in $TOOL and start asking about HealthOmics!"

# Tool-specific notes
case $TOOL in
    claude-code)
        echo ""
        echo "Use '/healthomics' in a conversation to activate the skill."
        ;;
    kiro-cli)
        echo ""
        echo "Activate the agent with: /agent healthomics"
        echo "Or press Ctrl+Shift+H in a chat session."
        ;;
    cline)
        echo ""
        echo "Note: Copy cline_mcp_settings.json content into your Cline MCP settings"
        echo "      (Settings → MCP Servers → Edit Config)"
        ;;
    roo-code)
        echo ""
        echo "The .roo/mcp.json provides project-level MCP configuration."
        echo "No additional merge step needed — Roo Code reads it automatically."
        ;;
    windsurf)
        echo ""
        echo "Note: Merge mcp_config.json into ~/.codeium/windsurf/mcp_config.json"
        echo "      or your workspace MCP configuration."
        ;;
    codex)
        echo ""
        echo "Note: Merge config.toml contents into ~/.codex/config.toml"
        echo "      to enable the MCP server globally."
        ;;
    gemini-cli)
        echo ""
        echo "Note: The .gemini/ directory contains settings.json (MCP config)"
        echo "      and GEMINI.md (context). Run 'gemini' from this project directory."
        ;;
esac
