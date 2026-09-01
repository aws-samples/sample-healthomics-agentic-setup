# Example 1: End-to-End Workflow Development

## Scenario

You need to build a new genomics workflow from scratch. You have a bioinformatics task — aligning paired-end FASTQ reads to a reference genome and producing a sorted BAM file — and you want to develop, validate, and deploy it entirely through your AI coding assistant.

This example showcases the full development lifecycle: writing WDL, linting, packaging, deploying to HealthOmics, and running the workflow.

## What You'll See

- AI-assisted WDL workflow authoring with HealthOmics best practices
- Automatic linting and validation before deployment
- Workflow packaging and deployment to AWS HealthOmics
- Container availability checks and ECR pull-through cache setup
- Running the deployed workflow with real data

## Prerequisites

- AWS credentials configured with HealthOmics, ECR, and S3 permissions
- An S3 bucket for workflow outputs
- An IAM service role for HealthOmics (with omics trust policy)

## Test Data

This example uses the publicly readable `aws-genomics-static-226637376468-<region>-an` bucket (e.g., `aws-genomics-static-226637376468-us-east-1-an`) which contains FASTQ, BAM, and reference data suitable for testing.

## Prompts

### Prompt 1: Onboarding and Configuration

```
I want to start using AWS HealthOmics. My account ID is 123456789012, my HealthOmics
service role is arn:aws:iam::123456789012:role/OmicsWorkflowRole, and I want outputs
written to s3://my-genomics-bucket/healthomics-outputs/. Please set up my configuration.
```

> Replace the account ID, role, and bucket with your values.

**Expected behavior:** Creates `.healthomics/config.toml` with your settings and verifies AWS credentials.

---

### Prompt 2: Write the Workflow

```
Write me a WDL workflow that takes paired-end FASTQ files and a reference genome,
aligns them with BWA-MEM2, sorts the output with samtools, and marks duplicates with
samtools markdup. The final outputs should be a sorted, deduplicated BAM and its index.
Use appropriate containers from public registries.
```

**Expected behavior:** Writes a complete WDL 1.1 workflow with proper structure — tasks in a `tasks/` folder, a `main.wdl` entry point, `meta`/`parameter_meta` blocks, `set -eu` in commands, scatter-friendly design, and a README. It will also check container availability in ECR.

---

### Prompt 3: Lint and Fix

```
Lint the workflow and fix any issues.
```

**Expected behavior:** Validates the WDL, reports any warnings or errors, and fixes them automatically.

---

### Prompt 4: Set Up Containers

```
Set up ECR pull-through caches so HealthOmics can access the containers used in this workflow.
```

**Expected behavior:** Validates ECR configuration, creates pull-through cache rules for the required registries (e.g., Docker Hub, Quay.io), and generates a container registry map.

---

### Prompt 5: Deploy the Workflow

```
Package and deploy this workflow to HealthOmics.
```

**Expected behavior:** Packages the workflow into a ZIP, deploys it with the container registry map, and verifies the workflow reaches `ACTIVE` status.

---

### Prompt 6: Find Test Data and Run

```
Search for suitable input files in the aws-genomics-static-226637376468-us-east-1-an/omics-data/ bucket that I can use
to test this workflow, then start a run.
```

**Expected behavior:** Searches for suitable FASTQ pairs and reference genome, constructs a parameters file, and starts a workflow run using your configured role and output location.

> Replace `us-east-1` with your region if different.
