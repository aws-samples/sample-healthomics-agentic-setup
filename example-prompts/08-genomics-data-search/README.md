# Example 8: Genomics Data Search

## Scenario

You have genomics data (FASTQ, BAM, CRAM, VCF, FASTA files) scattered across multiple S3 buckets and HealthOmics Sequence Stores. Before you can run a workflow, you need to find the right files — and most genomics tools require not just the primary data file but also its associated index files (BAI, CRAI, TBI, FAI, dict, BWA indexes). Manually locating these file collections is tedious and error-prone.

This example showcases intelligent genomics data search: discovering files across storage systems, automatically grouping primary files with their indexes, and assembling discovered files into ready-to-use workflow input parameters.

## What You'll See

- Searching for specific genomics file types across S3 buckets
- Automatic discovery of associated index files
- Finding paired-end FASTQ collections by sample name
- Locating reference genomes with complete index sets
- Searching across multiple S3 buckets simultaneously
- Assembling discovered files into workflow input parameter mappings
- Querying HealthOmics Sequence Stores for imported read sets

## Prerequisites

- AWS credentials configured with HealthOmics, S3, and IAM permissions

## Test Data

The publicly readable `aws-genomics-static-226637376468-<region>-an` bucket (e.g., `aws-genomics-static-226637376468-us-east-1-an`) contains FASTQ, BAM, CRAM, VCF, and reference FASTA files.

## Prompts

### Prompt 1: Search for Genomics Files

```
Search for sequence reads in s3://aws-genomics-static-226637376468-us-east-1-an/omics-data/
```

**Expected behavior:** Searches for FASTQ files and returns results with file paths, sizes, associated files (paired reads, index files), and file type distribution.

> Replace `us-east-1` with your region if different.

---

### Prompt 2: Explore Supported File Types

```
What genomics file types can the search support? What formats are searched and what
associated index files are included in the results?
```

**Expected behavior:** Explains the types of files you can search for along with their associated formats, index and auxiliary files.

---

### Prompt 3: Find BAM Files with Their Indexes

```
Search for BAM files in the aws-genomics-static-226637376468-us-east-1-an/omics-data bucket. I need to find
aligned reads that have associated index files so I can use them as inputs to
a variant calling workflow.
```

**Expected behavior:** Returns BAM files with associated BAI index files grouped together, indicating which BAMs are ready for use as workflow inputs.

---

### Prompt 4: Search for VCF Files

```
Find all variant call files in the aws-genomics-static-226637376468-us-east-1-an/omics-data/ bucket. I want to see which
ones have index files so I can use them for joint genotyping.
```

**Expected behavior:** Returns VCF/gVCF files with associated TBI or CSI index files, highlighting which are indexed and ready for random-access queries.

---

### Prompt 5: Find Paired-End FASTQs for a Sample

```
Search for FASTQ files matching "NA12878" in the aws-genomics-static-226637376468-us-east-1-an/omics-data/ bucket.
I need to find paired-end read files (R1 and R2) that I can use as inputs to a
read alignment workflow.
```

**Expected behavior:** Returns FASTQ files matching the sample name with paired-end associations (R1/R2 pairs grouped together), explaining how they map to workflow inputs.

---

### Prompt 6: Search for Reference Genomes

```
Find human reference genome files in the aws-genomics-static-226637376468-us-east-1-an/omics-data/ bucket. I need
a reference with its index files and dictionary for running GATK workflows.
```

**Expected behavior:** Returns FASTA reference files with associated indexes (FAI, dict, BWA indexes), identifying which references have complete index sets for different tools.

---

### Prompt 7: Search Across Multiple Buckets

```
Search for CRAM files across both the aws-genomics-static-226637376468-us-east-1-an/omics-data/ bucket and my
project bucket s3://my-genomics-project/samples/. Show me what's available with their index files.
```

**Expected behavior:** Searches multiple buckets, showing CRAM files with CRAI indexes and source identification.

---

### Prompt 8: Prepare Workflow Inputs from Search Results

```
I have a WDL workflow that takes these inputs:
  - input_bam: File (a BAM file)
  - input_bam_index: File (the BAI index)
  - ref_fasta: File (reference genome)
  - ref_fasta_index: File (FAI index)
  - ref_dict: File (sequence dictionary)

Search the aws-genomics-static-226637376468-us-east-1-an bucket for BAM and FASTA files and help me
assemble the correct input parameters for a workflow run.
```

**Expected behavior:** Performs multiple searches, presents discovered files organized by workflow input parameter, and suggests a complete parameter JSON.

---

### Prompt 9: Search with Pagination

```
Search for all genomics files in the aws-genomics-static-226637376468-us-east-1-an/omics-data/ bucket without
filtering by type. Show me the file type distribution and total count.
```

**Expected behavior:** Returns results with file type distribution metadata and pagination information for large result sets.

---

### Prompt 10: Find Data in HealthOmics Sequence Stores

```
List my HealthOmics sequence stores and search for read sets that belong to
subject "NA12878". I want to find what's already been imported.
```

**Expected behavior:** Lists existing stores, searches for read sets matching the subject, and shows metadata including file type, sample ID, and status.

---

### Prompt 11: End-to-End Data Discovery to Workflow Run

```
I want to run a FASTQ-to-BAM alignment workflow. Help me:
1. Find paired-end FASTQ files in aws-genomics-static-226637376468-us-east-1-an/omics-data/
2. Find a reference genome with BWA indexes
3. Show me how these map to typical alignment workflow inputs
```

**Expected behavior:** Performs multi-step data discovery, identifies paired-end collections and complete BWA index sets, and presents a summary mapping discovered files to standard alignment workflow parameters.
