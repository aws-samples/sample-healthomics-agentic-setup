---
name: aws-healthomics
description: Create, migrate, run, debug, and optimize genomics workflows in AWS HealthOmics. Use when the user asks about HealthOmics, WDL, Nextflow, CWL, genomics pipelines, or bioinformatics workflows on AWS.
---

# AWS HealthOmics Skill

This skill provides procedural knowledge for working with AWS HealthOmics workflows via the MCP server.

## Available Workflows

Load the appropriate reference file based on the task:

- **Create from Git repo** → `references/git-integration.md`
- **Create from local files** → `references/workflow-development.md`
- **Run a workflow** → `references/running-a-workflow.md`
- **Batch runs** → `references/batch-runs.md`
- **Migrate WDL** → `references/migration-guide-for-wdl.md`
- **Migrate Nextflow** → `references/migration-guide-for-nextflow.md`
- **Version/update workflow** → `references/workflow-versioning.md`
- **Troubleshoot failures** → `references/troubleshooting.md`
- **ECR containers** → `references/ecr-pull-through-cache.md`
- **Stage container images** → `references/image-staging.md`
- **VPC setup** → `references/vpc-setup.md`
- **VPC configuration** → `references/healthomics-configuration.md`
- **VPC connected runs** → `references/vpc-connected-workflow-runs.md`
- **Regional capabilities** → `references/regional-capabilities.md`

## Onboarding

1. Ensure valid AWS credentials are configured.
2. Run `aws sts get-caller-identity` to verify the account.
3. Check for or create `.healthomics/config.toml`:

```toml
omics_iam_role = "arn:aws:iam::<ACCOUNT_ID>:role/<HEALTHOMICS_ROLE_NAME>"
run_output_uri = "s3://<YOUR_BUCKET>/healthomics-outputs/"
run_storage_type = "DYNAMIC"
```
