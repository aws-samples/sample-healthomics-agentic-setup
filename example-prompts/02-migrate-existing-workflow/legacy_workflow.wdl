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
