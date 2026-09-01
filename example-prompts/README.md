# Example Prompts

Guided examples showing what you can accomplish with the AWS HealthOmics MCP server and steering documents. Each example is a self-contained scenario with prompts you can paste directly into your AI coding assistant.

## Getting Started

### Prerequisites

1. An **AWS account** with HealthOmics available in your region.
2. **AWS credentials** configured (via environment variables, AWS CLI profile, or IAM role).
3. The **HealthOmics MCP server** configured in your tool (see the [main README](../README.md) for setup).

### First-Time Setup

Before running any example, start with this onboarding prompt:

```
I want to start using AWS HealthOmics. My account ID is <ACCOUNT_ID>, my HealthOmics
service role is arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>, and I want outputs written
to s3://<BUCKET>/healthomics-outputs/. Please set up my configuration.
```

This creates a `.healthomics/config.toml` that all subsequent prompts will use.

> **Note:** The MCP server cannot create IAM roles or S3 buckets, but most AI coding assistants can use the AWS CLI to do this for you. Review any generated IAM policies before applying them.

### Test Data

The `aws-genomics-static-226637376468-<region>-an` S3 bucket (e.g., `aws-genomics-static-226637376468-us-east-1-an`) is publicly readable and contains genomics test data (FASTQ, BAM, CRAM, VCF, references). It is replicated in all HealthOmics regions. Many examples reference this bucket for inputs.

---

## Example Index

| # | Example | What It Shows | Time |
|---|---------|---------------|------|
| 1 | [Workflow Development](./01-workflow-development/) | Write WDL, lint, package, deploy, run | 15–20 min |
| 2 | [Migrate Existing Workflow](./02-migrate-existing-workflow/) | Audit, upgrade syntax, migrate containers, deploy | 10–15 min |
| 3 | [Git Integration](./03-git-integration/) | Deploy from GitHub, container setup, run pipeline | 10–15 min |
| 4 | [Troubleshooting Failures](./04-troubleshooting-failures/) | Diagnose, fix, version, re-run with caching | 10–15 min |
| 5 | [Performance Optimization](./05-performance-optimization/) | Analyze utilization, right-size, timeline visualization | 10–15 min |
| 6 | [Batch Runs](./06-batch-runs/) | Multi-sample submission, monitoring, partial retry | 10–15 min |
| 7 | [Container Management](./07-container-management/) | ECR validation, pull-through caches, registry maps | 10–15 min |
| 8 | [Genomics Data Search](./08-genomics-data-search/) | File search, index discovery, workflow input assembly | 10–15 min |

---

## Suggested Paths

### New to HealthOmics (~30 min)
1. **Example 1** (Workflow Development) — full lifecycle from writing to running
2. **Example 4** (Troubleshooting) — what happens when things go wrong

### Migrating from Cromwell or on-prem (~20 min)
1. **Example 2** (Migrate Existing Workflow) — systematic migration
2. **Example 7** (Container Management) — solving the #1 onboarding blocker

### Production-scale processing (~25 min)
1. **Example 6** (Batch Runs) — cohort-scale processing
2. **Example 5** (Performance Optimization) — cost reduction

### Platform and infrastructure (~20 min)
1. **Example 7** (Container Management) — ECR configuration
2. **Example 3** (Git Integration) — CI/CD-style deployment from source control

### Quick showcase (~10 min)
1. **Example 4**, Prompts 1–3 — diagnose a failure in seconds
2. **Example 5**, Prompts 1 and 3 — performance analysis + timeline visualization
