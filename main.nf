#!/usr/bin/env nextflow

// include modules

include {fastqc } from './modules/fastqc.nf'
include {FASTP } from './modules/fastp.nf'
include {FASTP_FASTQC } from './modules/fastp_fastqc.nf'
include {HISAT2_BUILD } from './modules/hisat2.nf'
include {HISAT2_ALIGN } from './modules/hisat2.nf'
include {SORT_INDEX } from './modules/sort_index.nf'
include {QUALIMAP} from './modules/qualimap.nf'
include {FEATURECOUNTS} from './modules/featurecounts.nf'


// input paramters

params.input_csv = "data/reads.csv"

workflow {
	read_ch = Channel.fromPath(params.input_csv)
		.splitCsv(header:true)
		.map { row -> [file(row.fastq_1), file(row.fastq_2)]}

	genome_fasta = Channel.fromPath('refs/genome.fa')	
	gtf_file = Channel.fromPath('refs/22.gtf')

	///initial QC
	fastqc(read_ch)

	///fastp
	FASTP(read_ch)
	
	///fastp_fastqc
	FASTP_FASTQC(FASTP.out.trimmed_reads)

        //Build index once
        HISAT2_BUILD(genome_fasta)

	//ALIGN with hisat2
	HISAT2_ALIGN(
		FASTP.out.trimmed_reads,
		HISAT2_BUILD.out.hisat2_index.collect()
		)

	// convert to sam, sort and index
	SORT_INDEX(HISAT2_ALIGN.out.aligned_sam)

	//qualimap
	QUALIMAP(
		SORT_INDEX.out.sorted_bam,
		SORT_INDEX.out.bam_index,
		gtf_file.collect()
)

	//featureCounts
	FEATURECOUNTS(
		SORT_INDEX.out.sorted_bam.collect(),
		gtf_file)

}

