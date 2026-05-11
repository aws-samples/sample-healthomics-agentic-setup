---
applyTo: "**/*.wdl,**/*.nf,**/*.cwl,**/healthomics*,**/.healthomics/**"
---

# AWS HealthOmics

You have access to the AWS HealthOmics MCP server for creating, migrating, running, debugging, and optimizing genomics workflows.

## When to Load Steering Files

When performing tasks related to the following scenarios, read the appropriate steering file from the `steering/` directory before proceeding:

- Creating a workflow from a Git repository URL (GitHub, GitLab, Bitbucket) → read `steering/git-integration.md` (takes precedence over workflow-development.md)
- Creating a new WDL, Nextflow, or CWL workflow from local files → read `steering/workflow-development.md`
- Running a deployed HealthOmics workflow → read `steering/running-a-workflow.md`
- Submitting, monitoring, or managing batch runs (multiple samples/runs at once) → read `steering/batch-runs.md`
- Onboarding an existing WDL workflow for HealthOmics compatibility → read `steering/migration-guide-for-wdl.md`
- Onboarding an existing Nextflow workflow for HealthOmics compatibility → read `steering/migration-guide-for-nextflow.md`
- Modifying, updating, or fixing an existing HealthOmics workflow → read `steering/workflow-versioning.md`
- Diagnosing workflow creation issues or run failures → read `steering/troubleshooting.md`
- Using public containers with HealthOmics via ECR Pull-Through Caches → read `steering/ecr-pull-through-cache.md`
- Setting up VPC infrastructure for HealthOmics workflows → read `steering/vpc-setup.md`
- Managing HealthOmics VPC configurations (creating, listing, getting, or deleting) → read `steering/healthomics-configuration.md`
- Running workflows with VPC connectivity, public internet access, or cross-region access → read `steering/vpc-connected-workflow-runs.md`

## Onboarding

1. **Ensure valid AWS credentials** — The MCP server uses these to interact with AWS services.
2. **Get the current account** — Run `aws sts get-caller-identity`.
3. **Create `.healthomics/config.toml`** with run parameters:

```toml
omics_iam_role = "arn:aws:iam::<ACCOUNT_ID>:role/<HEALTHOMICS_ROLE_NAME>"
run_output_uri = "s3://<YOUR_BUCKET>/healthomics-outputs/"
run_storage_type = "DYNAMIC"
```

Ask the user for `omics_iam_role` and `run_output_uri` values, or offer to create them.

## Dependencies

This configuration requires [`uvx`](https://docs.astral.sh/uv/getting-started/installation/) (part of the `uv` Python package manager).
