# RNA-seq Analysis Pipeline with Nextflow

A complete RNA-seq analysis pipeline built with Nextflow for processing paired-end Illumina sequencing data from raw reads to gene expression counts.

## Pipeline Overview

This pipeline performs the following analyses:

1. **Quality Control** - FastQC on raw reads
2. **Read Trimming** - fastp for adapter removal and quality trimming
3. **Post-trim Quality Control** - FastQC on trimmed reads
4. **Reference Indexing** - HISAT2 index building
5. **Read Alignment** - HISAT2 alignment to reference genome
6. **Post-alignment Processing** - SAM to BAM conversion, sorting, and indexing with samtools
7. **Alignment Quality Assessment** - Qualimap for BAM QC and RNA-seq specific metrics
8. **Gene Quantification** - featureCounts for gene expression counting

## Pipeline Workflow

```
Raw FASTQ files
    ↓
FastQC (raw reads)
    ↓
fastp (quality and adapter trimming)
    ↓
FastQC (trimmed reads)
    ↓
HISAT2 (alignment) ← Reference genome index
    ↓
samtools (SAM→BAM, sort, index)
    ↓
Qualimap (alignment QC)
    ↓
featureCounts (gene counting) ← GTF annotation
    ↓
Gene expression matrix
```

## Quick Start

### Installation

```
# Clone the repository
git clone https://github.com/krishnanyadhu/rnaseq-nextflow-pipeline.git
cd rnaseq-nextflow-pipeline
```

### Running the Pipeline

```
# Basic usage
nextflow run main.nf

# With custom parameters
nextflow run main.nf \
  --reads 'data/reads/*_{1,2}.fastq.gz' \
  --genome 'refs/genome.fa' \
  --gtf 'refs/annotation.gtf'

# Resume a failed run
nextflow run main.nf -resume
```

## Input Requirements

### Directory Structure

```
your-project/
├── data/
│   └── reads/
│       ├── sample1_1.fastq.gz
│       ├── sample1_2.fastq.gz
│       ├── sample2_1.fastq.gz
│       ├── sample2_2.fastq.gz
│       └── ...
├── refs/
│   ├── genome.fa
│   └── annotation.gtf
├── main.nf
└── modules/
```

### Input Files

- **Paired-end FASTQ files**: Compressed (.gz) paired-end sequencing data
  - Naming convention: `*_{1,2}.fastq.gz` or `*_R{1,2}.fastq.gz`
- **Reference genome**: FASTA format (.fa or .fasta)
- **Gene annotation**: GTF format (.gtf)


## Key Output Files

- **`results/05_gene_counts/counts.txt`**: Main gene expression count matrix (ready for DESeq2/edgeR)
- **`results/04_quality_assessment/qualimap/`**: HTML reports for alignment quality assessment
- **`results/01_quality_control/`**: FastQC HTML reports for read quality evaluation

## Configuration


## Tools and Versions

- **Nextflow**: ≥21.04.0
- **FastQC**: 0.12.1
- **fastp**: 0.23.4
- **HISAT2**: 2.2.1
- **samtools**: 1.19.2
- **Qualimap**: 2.3
- **Subread (featureCounts)**: 2.0.6


## Pipeline Features

- **Modular Design**: Each analysis step is in a separate module for easy maintenance
- **Automatic Caching**: Nextflow caches completed tasks to enable quick reruns with `-resume`
- **Parallel Processing**: Automatically parallelizes sample processing
- **Resource Optimization**: Configurable CPU and memory allocation per process


### Cleaning Up

```
# Remove work directory and cached files
nextflow clean -f

# Remove all results to start fresh
rm -rf results/ work/ .nextflow*
```


## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please open an issue on GitHub or contact [yadhuryk@gmail.com].
```
