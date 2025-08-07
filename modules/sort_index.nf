#!/usr/bin/env nextflow

process SORT_INDEX {

publishDir "results/bam_files", mode: 'symlink'

	input:
	path sam_file

	output:
	path "*_sorted.bam", emit: sorted_bam
	path "*_sorted.bam.bai", emit: bam_index
	path "*_flagstat.txt", emit: flagstat

	script:
	def sample_id = sam_file.baseName.replaceAll(/_aligned.*/, '')
	"""
	samtools view -bS ${sam_file} | samtools sort -o ${sample_id}_sorted.bam

	samtools index ${sample_id}_sorted.bam

	samtools flagstat ${sample_id}_sorted.bam > ${sample_id}_flagstat.txt
	"""
}
