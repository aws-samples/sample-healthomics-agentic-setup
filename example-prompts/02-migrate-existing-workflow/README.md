# Example 2: Migrate an Existing WDL Workflow to HealthOmics

## Scenario

You have an existing workflow that runs on Cromwell or another execution engine. It uses Docker Hub containers directly, has draft-2 syntax, and references local file paths. You want to migrate it to AWS HealthOmics without changing the scientific logic.

This example showcases the migration capabilities — the agent audits the workflow, identifies incompatibilities, and systematically fixes them.

## What You'll See

- Automated analysis of an existing WDL workflow for HealthOmics compatibility
- WDL version upgrade (draft-2 → 1.1)
- Container inventory and ECR migration
- Runtime attribute auditing and correction
- Input file path conversion to S3 URIs
- Deployment and validation on HealthOmics

## Prerequisites

- AWS credentials configured with HealthOmics, ECR, and S3 permissions
- An existing WDL workflow (or use the sample provided below)
- An S3 bucket with reference data and sample inputs

## Sample Workflow

Create this file as `legacy_workflow.wdl` before starting:

```wdl
workflow VariantCalling {
    File input_bam
    File reference_fasta
    String sample_name

    call HaplotypeCaller {
        input:
            bam = input_bam,
            ref = reference_fasta,
            sample = sample_name
    }

    call FilterVariants {
        input:
            vcf = HaplotypeCaller.output_vcf
    }

    output {
        File final_vcf = FilterVariants.filtered_vcf
    }
}

task HaplotypeCaller {
    File bam
    File ref
    String sample

    command {
        gatk HaplotypeCaller \
            -I ${bam} \
            -R ${ref} \
            -O ${sample}.g.vcf.gz \
            --emit-ref-confidence GVCF
    }

    runtime {
        docker: "broadinstitute/gatk:4.4.0.0"
    }

    output {
        File output_vcf = "${sample}.g.vcf.gz"
    }
}

task FilterVariants {
    File vcf

    command {
        gatk VariantFiltration \
            -V ${vcf} \
            --filter-expression "QD < 2.0" \
            --filter-name "LowQD" \
            -O filtered.vcf.gz
    }

    runtime {
        docker: "broadinstitute/gatk:4.4.0.0"
    }

    output {
        File filtered_vcf = "filtered.vcf.gz"
    }
}
```

## Prompts

### Prompt 1: Analyze the Workflow

```
I have a WDL workflow in legacy_workflow.wdl that currently runs on Cromwell.
I want to migrate it to AWS HealthOmics. Can you analyze it and tell me what
needs to change?
```

**Expected behavior:** Reads the file, identifies draft-2 syntax, missing version declaration, `${}` interpolation, missing CPU/memory runtime attributes, Docker Hub container references, and missing workflow input block. Produces a migration plan.

---

### Prompt 2: Perform the Migration

```
Go ahead and migrate this workflow to be HealthOmics compatible. Use WDL 1.1 syntax.
```

**Expected behavior:** Rewrites the workflow with:
- `version 1.1` declaration
- Proper `input {}` blocks
- `~{}` interpolation syntax
- `command <<< >>>` delimiters
- `set -eu` in commands
- CPU and memory runtime attributes (≥2 vCPU, ≥4 GiB)
- `meta` and `parameter_meta` blocks

---

### Prompt 3: Handle Containers

```
Migrate the containers to ECR so HealthOmics can access them.
```

**Expected behavior:** Checks if a Docker Hub pull-through cache exists, creates one if needed, verifies the GATK container is accessible, and either creates a container registry map or updates the WDL to use ECR URIs directly.

---

### Prompt 4: Validate and Deploy

```
Lint the migrated workflow, fix any remaining issues, then package and deploy it.
```

**Expected behavior:** Lints the WDL, resolves any issues, packages the workflow, and deploys it to HealthOmics. Verifies the workflow reaches `ACTIVE` status.

---

### Prompt 5: Create Test Inputs

```
Create a parameters.json for this workflow. Search the aws-genomics-static-226637376468-us-east-1-an/omics-data/
bucket for a suitable reference genome and BAM file I can use for testing.
```

**Expected behavior:** Searches for a reference FASTA and BAM file in the public test bucket, creates a properly formatted `parameters.json`, and validates that the S3 paths are accessible.

---

### Prompt 6 (Optional): Start a Workflow Run

```
Start a run of the deployed workflow using the parameters.json file.
```

**Expected behavior:** Starts a HealthOmics workflow run using the deployed workflow ID and parameters file, reports the run ID, and provides guidance on checking progress.
