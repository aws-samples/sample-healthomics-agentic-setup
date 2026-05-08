# Example 7: Container Management and ECR Configuration

## Scenario

AWS HealthOmics requires all container images to be in private ECR repositories with specific access permissions. When working with bioinformatics tools from Docker Hub, Quay.io, or ECR Public, you need to set up pull-through caches, validate permissions, and generate registry maps. This is often the most confusing part of HealthOmics onboarding.

This example showcases the complete container management workflow — from validating your ECR setup to making any public container accessible to HealthOmics.

## What You'll See

- ECR configuration validation for HealthOmics
- Pull-through cache creation for Docker Hub, Quay.io, and ECR Public
- Container availability checking with automatic pull-through
- Container cloning for unsupported registries
- Repository permission management
- Container registry map generation for workflow deployment

## Prerequisites

- AWS credentials configured with ECR, Secrets Manager, and HealthOmics permissions
- For Docker Hub pull-through: a Docker Hub access token stored in Secrets Manager

## Prompts

### Prompt 1: Validate Current Setup

```
Validate my ECR configuration for HealthOmics. Tell me what's working
and what needs to be fixed.
```

**Expected behavior:** Checks pull-through cache rules, registry permissions policy, repository creation templates, and returns a clear report of issues with remediation steps.

---

### Prompt 2: Set Up Pull-Through Caches

```
Set up ECR pull-through caches for Docker Hub, Quay.io, and ECR Public so my
HealthOmics workflows can use containers from those registries.
My Docker Hub credentials are stored in Secrets Manager at
arn:aws:secretsmanager:us-east-1:123456789012:secret:ecr-pullthroughcache/docker-hub-AbCdEf
```

**Expected behavior:**
1. Checks for existing pull-through cache rules
2. Creates rules for Docker Hub (with credentials), Quay.io, and ECR Public
3. Automatically configures registry permissions and repository templates
4. Validates the final configuration

---

### Prompt 3: Check Specific Containers

```
I need these containers for my workflow. Check if they're available and
accessible by HealthOmics:
- broadinstitute/gatk:4.5.0.0
- quay.io/biocontainers/samtools:1.19--h50ea8bc_1
- quay.io/biocontainers/bwa-mem2:2.2.1--he513fc3_0
```

**Expected behavior:** Checks each container, reports availability and HealthOmics access status, initiates pull-through for first-time access, and returns the ECR URI to use in workflows.

---

### Prompt 4: Clone a Container from an Unsupported Registry

```
I also need a container from the Seqera Wave registry:
wave.seqera.io/wt/abc123/biocontainers/fastqc:0.12.1
Clone it to my ECR so HealthOmics can use it.
```

**Expected behavior:** Handles registries not supported by pull-through cache by cloning the container to a private ECR repository with HealthOmics access permissions.

---

### Prompt 5: Generate a Container Registry Map

```
Generate a container registry map that I can use when deploying workflows.
Include all my pull-through caches and add a specific image mapping for
the Wave container we just cloned.
```

**Expected behavior:** Produces a JSON registry map that auto-discovers pull-through cache rules and includes custom image mappings, ready to use with workflow deployment.

---

### Prompt 6: Grant Access to an Existing Repository

```
I have an existing ECR repository called "my-custom-tools/variant-annotator"
that I built myself. Grant HealthOmics access to pull from it.
```

**Expected behavior:** Adds the HealthOmics service principal to the repository policy with the required permissions, preserving any existing policy statements.

---

### Prompt 7: List All Accessible Repositories

```
Show me all my ECR repositories and which ones HealthOmics can access.
```

**Expected behavior:** Lists repositories with their HealthOmics accessibility status, making it easy to spot repositories that need permission updates.
