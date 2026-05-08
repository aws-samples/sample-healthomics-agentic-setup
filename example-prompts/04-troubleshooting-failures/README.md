# Example 4: Diagnose and Fix a Failed Workflow Run

## Scenario

Your workflow run has failed and you need to understand why. Rather than manually digging through CloudWatch logs, run manifests, and task details, you want the AI agent to diagnose the failure, explain the root cause, fix the workflow, and re-run it.

This example showcases the troubleshooting and iterative development loop: diagnose → fix → version → re-run.

## What You'll See

- Automated failure diagnosis with log analysis
- Engine log and task log interpretation
- Root cause identification and explanation
- Workflow fix and versioning
- Re-run with run cache for cost efficiency

## Prerequisites

- AWS credentials configured with HealthOmics and CloudWatch Logs permissions
- A failed workflow run (or trigger one intentionally — see Setup below)

## Setup (Creating a Failure)

To create a realistic failure scenario, deploy a workflow with an intentional issue:
- A task that references a non-existent S3 input
- A container command that exits with a non-zero code
- A task with insufficient memory for its workload

If you already have a failed run ID from previous work, skip directly to Prompt 1.

## Prompts

### Prompt 1: Check Run Status

```
List my recent HealthOmics runs and show me any that have failed.
```

**Expected behavior:** Lists recent runs with their statuses, workflow IDs, and timestamps.

---

### Prompt 2: Diagnose the Failure

```
Diagnose run <RUN_ID> and tell me what went wrong.
```

*(Replace `<RUN_ID>` with an actual failed run ID from Prompt 1)*

**Expected behavior:** Collects run details, engine logs, and task logs. Explains the root cause in plain language and suggests a fix.

---

### Prompt 3: Get Detailed Task Information

```
Show me the details of the failed tasks, including their resource usage and logs.
```

**Expected behavior:** Shows CPU/memory allocation, instance type, container image, and stderr output for each failed task.

---

### Prompt 4: Fix and Redeploy

```
Fix the issue in the workflow and deploy a new version.
```

**Expected behavior:**
1. Edits the workflow definition to fix the identified issue
2. Lints the updated workflow
3. Packages it
4. Creates a new workflow version (patch version bump)
5. Verifies the new version is `ACTIVE`

---

### Prompt 5: Re-run with Caching

```
Re-run the workflow with the fix. Use a run cache so we don't repeat
tasks that already succeeded.
```

**Expected behavior:** Creates or reuses a run cache, starts a new run with caching enabled, and references the new workflow version with the same parameters as the original failed run.

---

### Prompt 6: Verify Success

```
Check if the re-run completed successfully and show me the timeline.
```

**Expected behavior:** Confirms `COMPLETED` status and produces a timeline showing task execution. Cached tasks show as near-instant, demonstrating cost savings.

---

## Common Failure Patterns

The agent handles these well:
- Permission errors (IAM role can't read S3 or pull ECR images)
- Out-of-memory kills
- Container not found
- Input file not found
- Command script errors (exit code non-zero)
