# Example 3: Deploy a Workflow from a Git Repository

## Scenario

You want to deploy a WDL variant-calling pipeline from a public GitHub repository to AWS HealthOmics without manually cloning, modifying, or packaging the code. HealthOmics supports direct Git integration — the agent handles CodeConnections, container registry maps, and deployment in a single conversational flow.

This example uses the **variant-calling-pipeline** from [`aws-samples/amazon-omics-tutorials`](https://github.com/aws-samples/amazon-omics-tutorials/tree/main/example-workflows/wdl/variant-calling-pipeline), a WDL 1.1 workflow that performs short-read variant calling using BWA-MEM alignment, samtools sorting/indexing, and bcftools variant calling.

## Pipeline Overview

```
FASTQ files (per sample)
  │
  ▼
┌─────────────────────────────────┐
│ 1. bwa index  (optional)       │  Build BWA index from reference FASTA
└────────────┬────────────────────┘
             ▼
┌─────────────────────────────────┐
│ 2. bwa mem  (scatter)          │  Align reads to reference genome
└────────────┬────────────────────┘
             ▼
┌─────────────────────────────────┐
│ 3. samtools sort  (scatter)    │  Coordinate-sort aligned BAMs
└────────────┬────────────────────┘
             ▼
┌─────────────────────────────────┐
│ 4. samtools index  (scatter)   │  Index sorted BAMs (.bai)
└────────────┬────────────────────┘
             ▼
┌─────────────────────────────────┐
│ 5. bcftools mpileup  (gather)  │  Multi-sample pileup across all BAMs
└────────────┬────────────────────┘
             ▼
┌─────────────────────────────────┐
│ 6. bcftools call  (gather)     │  Call variants → VCF
└────────────┬────────────────────┘
             ▼
         all.vcf
```

Steps 2–4 run in parallel across samples (scatter). Steps 5–6 gather all samples for joint calling.

## What You'll See

- CodeConnection creation and OAuth flow management
- Direct workflow deployment from GitHub using a repository subfolder path
- Container registry map generation for Quay.io BioContainers
- ECR pull-through cache validation and setup
- Running a real variant-calling pipeline with public test data

## Prerequisites

- AWS credentials configured with HealthOmics, ECR, CodeConnections, and S3 permissions
- A GitHub account (for OAuth authorization)
- An S3 bucket for workflow outputs

## Prompts

### Prompt 1: Set Up Git Connection

```
I want to deploy the variant-calling-pipeline from the aws-samples/amazon-omics-tutorials
GitHub repository to HealthOmics. Can you help me set up the connection?
```

**Expected behavior:** Checks for existing GitHub connections. If none exist, creates a CodeConnection and provides the AWS Console URL to complete OAuth authorization.

---

### Prompt 2: Validate Containers and Deploy the Pipeline

```
The connection is authorized. Before deploying, make sure my ECR is set up to pull
the BioContainers images from Quay.io that this workflow needs (bwa, samtools, bcftools).
Then deploy the variant-calling-pipeline from aws-samples/amazon-omics-tutorials.
The workflow is in the subfolder example-workflows/wdl/variant-calling-pipeline
on the main branch.
```

**Expected behavior:**
1. Verifies the CodeConnection is `AVAILABLE`
2. Checks for an ECR pull-through cache rule for Quay.io; creates one if missing
3. Validates that the BioContainers images are accessible
4. Creates a container registry map
5. Deploys the workflow from the Git repository
6. Monitors until it reaches `ACTIVE` status

---

### Prompt 3: Explore the Deployed Workflow

```
Show me the details of the deployed variant-calling-pipeline workflow, including
its parameters and resource requirements.
```

**Expected behavior:** Displays the workflow details — type, status, parameter template, creation time, and storage configuration.

---

### Prompt 4: Run the Pipeline with Public Test Data

```
Run the variant-calling-pipeline with the public test data from the
aws-genomics-static-us-east-1 bucket:
- samples: ["SRR2089363", "SRR2089364"]
- fastq_files from s3://aws-genomics-static-us-east-1/omics-data/tumor-normal/fastqs/
- Reference genome and BWA index from s3://aws-genomics-static-us-east-1/omics-data/test-datasets/nf-core-sarek/reference/chr20_hg38/
- Use pre-built BWA index files (run_bwa_index: false)
- Use DYNAMIC storage
```

**Expected behavior:** Constructs the full parameter set, resolves S3 paths for the reference and BWA index files, starts the run, and monitors initial status.

---

### Prompt 5: Monitor and Troubleshoot the Run

```
Show me the status of my latest HealthOmics run. If any tasks failed,
diagnose the failure.
```

**Expected behavior:** Checks overall run status and per-task progress. If any task failed, retrieves logs and provides a diagnosis.

---

### Prompt 6: Deploy a Specific Commit

```
I want to pin this deployment to a specific commit for reproducibility.
Deploy the variant-calling-pipeline again from aws-samples/amazon-omics-tutorials
at commit abc1234 and name it "variant-calling-pipeline-pinned".
```

**Expected behavior:** Creates a second workflow using the same CodeConnection but pinned to a specific commit hash — demonstrating reproducible deployments for regulated environments.
