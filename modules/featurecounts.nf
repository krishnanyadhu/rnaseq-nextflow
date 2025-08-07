#!/usr/bin/env nextflow

process FEATURECOUNTS {

	publishDir "output/gene_counts", mode: 'copy'

	input:
	path sorted_bam
	path gtf_file
	
	output:
	path "counts.txt", emit: gene_counts
	path "counts.txt.summary", emit: count_summary

	script:
	"""
	featureCounts -p --countReadPairs -a ${gtf_file} -o counts.txt ${sorted_bam.join(' ')}
	"""
}
