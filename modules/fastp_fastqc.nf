#!/usr/bin/env nextflow

process FASTP_FASTQC {

	publishDir "results/fastp_fastqc", mode: 'symlink'

	input:
	tuple path(read1_trimmed), path(read2_trimmed)
	
	output:
	path "*_fastqc.html", emit: html
	path "*_fastqc.zip", emit: zip

	script:
	"""
	fastqc ${read1_trimmed} ${read2_trimmed}
	"""
}
