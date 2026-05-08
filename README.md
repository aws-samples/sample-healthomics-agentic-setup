# AWS HealthOmics Agentic Tool Adapters

Use AWS HealthOmics with your preferred AI coding assistant. This package provides drop-in configurations that connect the [AWS HealthOmics MCP Server](https://github.com/awslabs/mcp/tree/main/src/aws-healthomics-mcp-server) and best-practice steering documents to your tool.

## Supported Tools

| Tool | Status | Global Install |
|------|--------|----------------|
| [Kiro IDE](#kiro-ide) | ✅ Via Power Store | N/A |
| [Kiro CLI](#kiro-cli) | ✅ | ✅ `~/.kiro/` |
| [Claude Code](#claude-code) | ✅ | ✅ `~/.claude/` |
| [Cursor](#cursor) | ✅ | ✅ `~/.cursor/` |
| [GitHub Copilot (VS Code)](#github-copilot) | ✅ | — |
| [Cline / Roo Code](#cline--roo-code) | ✅ | — |
| [Windsurf](#windsurf) | ✅ | — |
| [OpenAI Codex CLI](#openai-codex-cli) | ✅ | ✅ `~/.codex/` |
| [Google Gemini CLI](#google-gemini-cli) | ✅ | ✅ `~/.gemini/` |

## Quick Setup

```bash
./setup.sh
```

The interactive installer asks which tool you use and copies the right files into your project. For tools that support it (Kiro CLI, Claude Code, Cursor, Codex, Gemini CLI), you can choose between a **global** install (available in all projects) or a **local** install (project-specific).

## Prerequisites

1. **AWS credentials** configured in your environment (`aws configure` or environment variables).
2. **[`uv`](https://docs.astral.sh/uv/getting-started/installation/)** installed (provides `uvx` for running the MCP server):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

## Per-Tool Setup

### Kiro IDE

Install the AWS HealthOmics power from the Kiro Power Store, or copy the power into `.kiro/powers/aws-healthomics/`.

### Kiro CLI

**Global install** (recommended — available in all projects):

```bash
./setup.sh   # Choose 2, then 'g'
```

Installs to:
- `~/.kiro/agents/healthomics.json` — Agent configuration with MCP server and skills
- `~/.kiro/agents/healthomics-prompt.md` — Agent system prompt with steering file routing
- `~/.kiro/steering/` — Best-practice SOPs (with skill frontmatter for on-demand loading)

**Local install** (project-specific):

```bash
./setup.sh   # Choose 2, then 'l'
```

Files installed:
- `.kiro/agents/healthomics.json` — Agent configuration with MCP server and skills
- `.kiro/agents/healthomics-prompt.md` — Agent system prompt with steering file routing
- `steering/` — Best-practice SOPs (with skill frontmatter for on-demand loading)

Activate with `/agent healthomics` or press `Ctrl+Shift+H`.

### Claude Code

**Global install** (recommended — available in all projects):

```bash
./setup.sh   # Choose 3, then 'g'
```

Installs to:
- `~/.claude/.mcp.json` — MCP server configuration (merged if existing)
- `~/.claude/skills/healthomics/SKILL.md` — Skill definition with steering file routing
- `~/.claude/skills/healthomics/steering/` — Best-practice SOPs

**Local install** (project-specific):

```bash
./setup.sh   # Choose 3, then 'l'
```

Files installed:
- `.mcp.json` — MCP server configuration
- `.claude/skills/healthomics/SKILL.md` — Skill definition with steering file routing
- `.claude/skills/healthomics/steering/` — Best-practice SOPs

Use `/healthomics` in a conversation to activate the skill.

### Cursor

**Global install** (recommended — available in all projects):

```bash
./setup.sh   # Choose 4, then 'g'
```

Installs to:
- `~/.cursor/mcp.json` — MCP server configuration (merged if existing)
- `~/.cursor/rules/healthomics.mdc` — Rule with glob triggers for `.wdl`, `.nf`, `.cwl` files
- `~/.cursor/steering/` — Best-practice SOPs

**Local install** (project-specific):

```bash
./setup.sh   # Choose 4, then 'l'
```

Files installed:
- `.cursor/mcp.json` — MCP server configuration
- `.cursor/rules/healthomics.mdc` — Rule with glob triggers for `.wdl`, `.nf`, `.cwl` files
- `steering/` — Best-practice SOPs

### GitHub Copilot

```bash
./setup.sh   # Choose 5
```

Files installed:
- `.vscode/mcp.json` — MCP server configuration
- `.github/copilot-instructions.md` — Copilot workspace instructions
- `steering/` — Best-practice SOPs

### Cline / Roo Code

```bash
./setup.sh   # Choose 6
```

Then merge `cline_mcp_settings.json` into your Cline MCP settings (Settings → MCP Servers → Edit Config).

Files installed:
- `.clinerules` — Agent instructions with steering file routing
- `cline_mcp_settings.json` — MCP config to merge into Cline settings
- `steering/` — Best-practice SOPs

### Windsurf

```bash
./setup.sh   # Choose 7
```

Then merge `mcp_config.json` into `~/.codeium/windsurf/mcp_config.json`.

Files installed:
- `.windsurfrules` — Agent instructions with steering file routing
- `mcp_config.json` — MCP config to merge into Windsurf settings
- `steering/` — Best-practice SOPs

### OpenAI Codex CLI

**Global install** (recommended — available in all projects):

```bash
./setup.sh   # Choose 8, then 'g'
```

Installs to:
- `~/.codex/config.toml` — MCP server configuration (appended)
- `~/.codex/AGENTS.md` — Global agent instructions
- `~/.codex/skills/aws-healthomics/SKILL.md` — Skill definition with reference routing
- `~/.codex/skills/aws-healthomics/references/` — Best-practice SOPs

**Local install** (project-specific):

```bash
./setup.sh   # Choose 8, then 'l'
```

Files installed:
- `AGENTS.md` — Agent instructions with steering file routing
- `config.toml` — MCP server config snippet (merge into `~/.codex/config.toml`)
- `steering/` — Best-practice SOPs

### Google Gemini CLI

**Global install** (recommended — available in all projects):

```bash
./setup.sh   # Choose 9, then 'g'
```

Installs to:
- `~/.gemini/settings.json` — MCP server configuration (merged)
- `~/.gemini/GEMINI.md` — Global context instructions
- `~/.gemini/steering/` — Best-practice SOPs referenced from GEMINI.md

**Local install** (project-specific):

```bash
./setup.sh   # Choose 9, then 'l'
```

Files installed:
- `.gemini/settings.json` — MCP server configuration
- `.gemini/GEMINI.md` — Project context instructions
- `steering/` — Best-practice SOPs

## Post-Setup Configuration

After installing, create `.healthomics/config.toml` in your project:

```toml
omics_iam_role = "arn:aws:iam::<ACCOUNT_ID>:role/<HEALTHOMICS_ROLE_NAME>"
run_output_uri = "s3://<YOUR_BUCKET>/healthomics-outputs/"
run_storage_type = "DYNAMIC"
```

This tells the agent your default IAM role and output location for workflow runs.

## What You Can Do

Once configured, ask your AI assistant to:

- **Create workflows** — "Create a WDL workflow that aligns FASTQ files with BWA-MEM2"
- **Migrate workflows** — "Migrate this Nextflow pipeline to run on HealthOmics"
- **Run workflows** — "Run my variant calling workflow with these samples"
- **Batch runs** — "Run this workflow across all 50 samples in my cohort"
- **Debug failures** — "Why did my last workflow run fail?"
- **Set up containers** — "Configure ECR pull-through caches for my Docker Hub containers"
- **VPC networking** — "Set up VPC connectivity so my workflow can access the internet"
- **Git integration** — "Deploy this nf-core pipeline from GitHub to HealthOmics"

## Example Prompts

The [`example-prompts/`](./example-prompts/) directory contains guided scenarios you can paste directly into your AI assistant to see the HealthOmics MCP server in action. Each example is self-contained with step-by-step prompts and expected behavior:

| # | Example | What It Shows |
|---|---------|---------------|
| 1 | [Workflow Development](./example-prompts/01-workflow-development/) | Write WDL, lint, package, deploy, run |
| 2 | [Migrate Existing Workflow](./example-prompts/02-migrate-existing-workflow/) | Audit, upgrade syntax, migrate containers, deploy |
| 3 | [Git Integration](./example-prompts/03-git-integration/) | Deploy from GitHub, container setup, run pipeline |
| 4 | [Troubleshooting Failures](./example-prompts/04-troubleshooting-failures/) | Diagnose, fix, version, re-run with caching |
| 5 | [Performance Optimization](./example-prompts/05-performance-optimization/) | Analyze utilization, right-size, timeline visualization |
| 6 | [Batch Runs](./example-prompts/06-batch-runs/) | Multi-sample submission, monitoring, partial retry |
| 7 | [Container Management](./example-prompts/07-container-management/) | ECR validation, pull-through caches, registry maps |
| 8 | [Genomics Data Search](./example-prompts/08-genomics-data-search/) | File search, index discovery, workflow input assembly |

## Steering Documents

The `steering/` directory contains best-practice SOPs that guide the AI agent:

| File | Purpose |
|------|---------|
| `workflow-development.md` | Creating new WDL/Nextflow/CWL workflows |
| `running-a-workflow.md` | Executing deployed workflows |
| `batch-runs.md` | Submitting and managing batch runs |
| `workflow-versioning.md` | Updating existing workflows |
| `migration-guide-for-wdl.md` | Migrating WDL workflows to HealthOmics |
| `migration-guide-for-nextflow.md` | Migrating Nextflow workflows to HealthOmics |
| `troubleshooting.md` | Diagnosing creation and run failures |
| `ecr-pull-through-cache.md` | Container registry setup |
| `git-integration.md` | Deploying from Git repositories |
| `vpc-setup.md` | VPC infrastructure for workflow runs |
| `vpc-connected-workflow-runs.md` | Running workflows with VPC networking |
| `healthomics-configuration.md` | Managing HealthOmics configurations |

## Security

See [SECURITY.md](SECURITY.md) for security guidance including the shared responsibility model, credential management, data privacy considerations, and S3 bucket hardening requirements.

## License

MIT-0. See [LICENSE](LICENSE).
