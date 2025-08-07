#!/usr/bin/env nextflow

process HISAT2_BUILD {

	publishDir "refs", mode: 'copy'

	input:
	path genome_fasta

	output:
	path "genome_index.*", emit: hisat2_index

	script:
	"""
	hisat2-build ${genome_fasta} genome_index
	"""
}

process HISAT2_ALIGN {

	publishDir "results/alignment", mode: 'symlink'

	input:
	tuple path(read1_trimmed), path(read2_trimmed)
	path hisat2_index

	output:
	path "*_aligned.sam", emit: aligned_sam

	script:
	def sample_id = read1_trimmed.baseName.replaceAll(/_1_trimmed.*/, '')
	"""
	hisat2 -x genome_index -1 ${read1_trimmed} -2 ${read2_trimmed} -S ${sample_id}_aligned.sam
	"""
}
