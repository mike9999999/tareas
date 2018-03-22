# 1. Introduction \[[⇑top](http://catchenlab.life.illinois.edu/stacks/manual/#top)\]

Several molecular approaches have been developed to focus short reads to specific, restriction-enzyme anchored positions in the genome. Reduced representation techniques such as CRoPS, RAD-seq, GBS, double-digest RAD-seq, and 2bRAD effectively subsample the genome of multiple individuals at homologous locations, allowing for single nucleotide polymorphisms (SNPs) to be identified and typed for tens or hundreds of thousands of markers spread evenly throughout the genome in large numbers of individuals. This family of reduced representation genotyping approaches has generically been called genotype-by-sequencing (GBS) or Restriction-site Associated DNA sequencing (RAD-seq). For a review of these technologies, see  [Davey et al. 2011](http://www.nature.com/nrg/journal/v12/n7/abs/nrg3012.html)  or  [Andrews, et al., 2016](http://doi.org/10.1038/nrg.2015.28).

_Stacks_  is designed to work with any restriction-enzyme based data, such as GBS, CRoPS, and both single and double digest RAD.  _Stacks_  is designed as a modular pipeline to efficiently curate and assemble large numbers of short-read sequences from multiple samples.  _Stacks_  identifies loci in a set of individuals, either  _de novo_  or aligned to a reference genome (including gapped alignments), and then genotypes each locus.  _Stacks_  incorporates a maximum likelihood statistical model to identify sequence polymorphisms and distinguish them from sequencing errors.  _Stacks_  employs a Catalog to record all loci identified in a population and matches individuals to that Catalog to determine which haplotype alleles are present at every locus in each individual.

_Stacks_  is implemented in C++ with wrapper programs written in Perl. The core algorithms are multithreaded via OpenMP libraries and the software can handle data from hundreds of individuals, comprising millions of genotypes.

_Stacks_  proceeds in six major stages. First, reads are demultiplexed and cleaned by the process_radtags program. The next three stages comprise the main  _Stacks_  pipeline: building loci (**ustacks**), creating the catalog of loci (**cstacks**), and matching against the catalog (**sstacks**). In the fifth stage, the  gstacks  program is executed to assemble and merge paired-end contigs, call variant sites in the population and genotypes in each sample. In the final stage, the  populations  program is executed, depending on the type of input data. This flow is diagrammed in the following figure.

# 2. Installation  \[[⇑top](http://catchenlab.life.illinois.edu/stacks/manual/#top)\]

## 2.1 Prerequisites

_Stacks_  should build on any standard UNIX-like environment (Apple OS X, Linux, etc.)  _Stacks_  is an independent pipeline and can be run without any additional external software.
##  2.2 Build the software
_Stacks_ uses the standard autotools install:



`%tar xfvz stacks-2.xx.tar.gz`

`% cd stacks-2.xx`
 
`% ./configure`

`% make`

`(become root)`

`%make install(or, use sudo)` 

`% sudo make instal`

You can change the root of the install location ( `/usr/local/`on most operating systems) by specifying the command `--prefix`line option to the configure script.

   

    ./configure --prefix=/home/smith/local

You can speed up the build if you have more than one processor:
`make -j 8`
A default install will install files in the following way:



`/usr/local/bin`       Stacks executables and Perl scripts.
The pipeline is now ready to run.

----------

# 3. What types of data does  _Stacks 2.0_  support?  \[[⇑top](http://catchenlab.life.illinois.edu/stacks/manual/#top)\]

_Stacks_  is designed to process data that  _stacks_  together. Primarily this consists of restriction enzyme-digested DNA. There are a few similar types of data that will stack-up and could be processed by  _Stacks_, such as DNA flanked by primers as is produced in metagenomic 16S rRNA studies.

The goal in  _Stacks_  is to assemble loci in large numbers of individuals in a population or genetic cross, call SNPs within those loci, and then read haplotypes from them. Therefore  _Stacks_  wants data that is a uniform length, with coverage high enough to confidently call SNPs. Although it is very useful in other bioinformatic analyses to variably trim raw reads, this creates loci that have variable coverage, particularly at the 3’ end of the locus. In a population analysis, this results in SNPs that are called in some individuals but not in others, depending on the amount of trimming that went into the reads assembled into each locus, and this interferes with SNP and haplotype calling in large populations.

## 3.1 Protocol Type

_Stacks_ supports all the major restriction-enzyme digest protocols such as RAD-seq, double-digest RAD-seq, and a subset of GBS protocols, among others.
#### Sequencer Type
_Stacks_  is optimized for short-read, Illumina-style sequencing. There is no limit to the length the sequences can be, although there is a hard-coded limit of 1024bp in the source code now for efficency reasons, but this limit could be raised if the technology warranted it.

_Stacks_  can also be used with data produced by the Ion Torrent platform, but that platform produces reads of multiple lengths so to use this data with  _Stacks_  the reads have to be truncated to a particular length, discarding those reads below the chosen length. **The  process_radtags**  program can truncate the reads from an Ion Torrent run.

Other sequencing technologies could be used in theory, but often the cost versus the number of reads obtained is prohibitive for building stacks and calling SNPs.
## 3.2Paired-end Reads

_Stacks_  directly supports paired-end reads, for both single and double digest protocols. In the case of a single-digest protocol,  _Stacks_  will use the staggered paired-end reads to assemble a contig across all of the individuals in the population. For double-digest RAD, both the single-end and paired-end reads are anchored by a contig and Stacks will assemble them into two loci. In both cases, the paired-end contig/locus will be merged with the single-end locus. If the loci do not overlap, they will be merged with a small buffer of  Ns in between them.

----------
# 4. Running the pipeline  \[[⇑top](http://catchenlab.life.illinois.edu/stacks/manual/#top)\]
## 4.1 Clean the data
In a typical analysis, data will be received from an Illumina sequencer, or some other type of sequencer as FASTQ files. The first requirement is to demultiplex, or sort, the raw data to recover the individual samples in the Illumina library. While doing this, we will use the [Phred](http://en.wikipedia.org/wiki/Phred_quality_score) scores provided in the FASTQ files to discard sequencing reads of low quality. These tasks are accomplished using the process_radtags program.
  
![](http://catchenlab.life.illinois.edu/stacks/manual/process_radtags.png)

