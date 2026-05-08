# Example 5: Performance Analysis and Optimization

## Scenario

Your workflow runs successfully but you suspect it's over-provisioned — tasks are requesting more CPU and memory than they actually use, costing you more than necessary. You want to analyze resource utilization and apply data-driven optimizations.

This example showcases the performance analysis loop: run → analyze → optimize → version → validate.

## What You'll See

- Run performance analysis with resource utilization metrics
- Task-level CPU and memory efficiency reporting
- Instance right-sizing recommendations with configurable headroom
- Timeline visualization showing task parallelism and bottlenecks
- Workflow versioning with optimized resource allocations
- Before/after cost comparison

## Prerequisites

- AWS credentials configured with HealthOmics and CloudWatch Logs permissions
- One or more **completed** workflow runs (the more runs analyzed, the better the recommendations)

## Test Data

If you need a completed run, use test data from the publicly readable `aws-genomics-static-<region>` bucket. Run a workflow from Example 1 or Example 2 with small inputs to produce a completed run you can analyze.

## Prompts

### Prompt 1: Analyze a Completed Run

```
Analyze the performance of run <RUN_ID> and tell me where I'm wasting resources.
```

*(Replace `<RUN_ID>` with a completed run ID)*

**Expected behavior:** Produces a structured report including per-task CPU utilization, memory utilization, instance type recommendations with headroom, and estimated cost savings.

---

### Prompt 2: Compare Multiple Runs

```
Analyze these three runs together and give me consolidated recommendations:
- <RUN_ID_1>
- <RUN_ID_2>
- <RUN_ID_3>
```

**Expected behavior:** Analyzes multiple runs simultaneously, providing more statistically robust recommendations by averaging resource usage across runs.

---

### Prompt 3: Visualize the Timeline

```
Generate a timeline visualization for run <RUN_ID>. Save it to timeline.svg.
```

**Expected behavior:** Produces an SVG Gantt chart showing task execution phases, color-coded status, parallelism patterns, and cost details.

---

### Prompt 4: Apply Optimizations

```
Apply the recommended resource optimizations to my workflow and deploy
a new version. Use aggressive optimization with no headroom for the
alignment tasks (they're very consistent) but keep 30% headroom for
the variant calling tasks.
```

**Expected behavior:**
1. Updates runtime attributes based on the analysis
2. Applies task-specific headroom as requested
3. Lints the updated workflow
4. Creates a new workflow version
5. Documents the changes

---

### Prompt 5: Validate the Optimization

```
Run the optimized workflow version with the same inputs as <RUN_ID> so
we can compare performance.
```

**Expected behavior:** Starts a new run using the optimized workflow version with identical parameters.

---

### Prompt 6: Compare Before and After

```
Compare the performance of the original run <RUN_ID> with the optimized
run <NEW_RUN_ID>. Show me the estimated cost difference.
```

**Expected behavior:** Presents a comparison showing runtime differences, resource utilization improvements, and cost reduction estimates if resources are over-provisioned.
