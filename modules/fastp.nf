#!/usr/bin/env nextflow


process FASTP {

    
    publishDir "results/fastp", mode: 'symlink'

    input:
    tuple path(read1), path(read2)

    output:
    tuple path("*_1_trimmed.fastq.gz"), path("*_2_trimmed.fastq.gz"), emit: trimmed_reads
    path "*_fastp.html", emit: html_report
    path "*_fastp.json", emit: json_report

    script:
    def sample_id = read1.baseName.replaceAll(/_R?1.*/, '')
    """
    fastp \\
        -i ${read1} \\
        -I ${read2} \\
        -o ${sample_id}_1_trimmed.fastq.gz \\
        -O ${sample_id}_2_trimmed.fastq.gz \\
        -h ${sample_id}_fastp.html \\
        -j ${sample_id}_fastp.json \\
        --detect_adapter_for_pe \\
       
    """
}

