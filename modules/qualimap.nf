#!/usr/bin/env nextflow

process QUALIMAP {

	publishDir "output/qualimap_reports", mode: 'copy'

	input:
	path(sorted_bam)
	path(bam_index)
	path(gtf_file)	

	output:
	path "*_bamqc_report", emit: bamqc_reports
	path "*_rnaseq_report", emit: rnaseq_reports

	script:
	def sample_id = sorted_bam.baseName.replaceAll(/_sorted.*/, '')
	"""
	qualimap bamqc -bam ${sorted_bam} -outdir ${sample_id}_bamqc_report --java-mem-size=6G
	qualimap rnaseq -bam ${sorted_bam} -gtf ${gtf_file} -outdir ${sample_id}_rnaseq_report --java-mem-size=6G
	"""

}
