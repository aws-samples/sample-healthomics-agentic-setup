# Example 6: Batch Runs Across a Sample Cohort

## Scenario

You have a validated workflow and need to run it across dozens or hundreds of samples in a cohort study. Rather than submitting runs one at a time, you want to use HealthOmics batch runs to submit them all at once, monitor progress, and handle any failures.

This example showcases batch run capabilities: preparation, submission, monitoring, failure handling, and lifecycle management.

## What You'll See

- Batch configuration with shared defaults and per-sample overrides
- Inline batch submission (≤100 samples)
- Batch progress monitoring and status tracking
- Individual run failure identification within a batch
- Batch cancellation and cleanup

## Prerequisites

- AWS credentials configured with HealthOmics and S3 permissions
- A deployed, `ACTIVE` private workflow (not a Ready2Run workflow)
- An IAM service role with `omics:StartRunBatch` and `omics:StartRun` permissions

## Prompts

### Prompt 1: Prepare and Submit the Batch

```
I have a variant calling workflow (workflow ID: <WORKFLOW_ID>) and I want to run it
across multiple samples. Search the aws-genomics-static-226637376468-us-east-1-an bucket for FASTQ
pairs I can use, then submit a batch run with up to 5 samples.
```

**Expected behavior:**
1. Verifies the workflow is `ACTIVE`
2. Searches for FASTQ pairs in the public test bucket
3. Constructs the batch configuration with shared defaults and per-sample overrides
4. Submits the batch
5. Reports the batch ID and initial status

---

### Prompt 2: Monitor Batch Progress

```
Check the status of my batch run. How many samples have completed?
```

**Expected behavior:** Shows overall batch status, submission summary, and run counts by state.

---

### Prompt 3: List Individual Runs

```
Show me the status of each individual run in the batch.
```

**Expected behavior:** Presents a table mapping each sample (runSettingId) to its run ID and current status.

---

### Prompt 4: Investigate a Failure

```
It looks like Sample-C failed. Diagnose what went wrong.
```

**Expected behavior:** Identifies the run ID for the failed sample, diagnoses the failure, and suggests remediation.

---

### Prompt 5: Re-run Failed Samples

```
Fix the issue and re-submit only the failed samples as a new batch.
```

**Expected behavior:** Creates a new batch containing only the corrected run configurations for the failed samples, using the same shared defaults.

---

### Prompt 6: Clean Up

```
The batch is complete. Delete the run data for the test batch to save on storage costs.
```

**Expected behavior:** Deletes the individual runs, then optionally removes the batch metadata. Explains the two-step cleanup process.

---

## Advanced: Large-Scale Batch (S3 Settings)

For production-scale processing with more than 100 samples:

```
I have 500 samples to process. The run configurations are stored at
s3://my-genomics-bucket/configs/cohort-500-configs.json. Submit this as a batch.
```

**Expected behavior:** Uses `s3UriSettings` instead of inline settings, demonstrating the scale-out path for up to 100,000 runs per batch.
