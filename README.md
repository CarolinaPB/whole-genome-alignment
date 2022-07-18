---
layout: page
---

[Link to the repository](https://github.com/CarolinaPB/whole-genome-alignment)

## First follow the instructions here:
[Step by step guide on how to use my pipelines](https://carolinapb.github.io/2021-06-23-how-to-run-my-pipelines/)  
Click [here](https://github.com/CarolinaPB/snakemake-template/blob/master/Short%20introduction%20to%20Snakemake.pdf) for an introduction to Snakemake

## ABOUT
This pipeline aligns one or more genomes to a specified genome and plots the alignment.


#### Tools used:
- [minimap2](https://github.com/lh3/minimap2)
- R
  - [pafCoordsDotPlotly.R](https://github.com/tpoorten/dotPlotly/blob/master/pafCoordsDotPlotly.R)


| ![DAG](https://github.com/CarolinaPB/whole-genome-alignment/blob/master/workflow.png) |
|:--:|
|*Pipeline workflow* |


### Edit config.yaml with the paths to your files
```yaml
# genome alignment parameters:
GENOME: /path/to/genome #genome fasta to be compared
COMPARISON_GENOME: 
  <genome1>: path/to/genome1.fasta
  <genome2>: path/to/genome2.fasta
  <genome3>: path/to/genome3.fasta

# filter alignments less than cutoff X bp
MIN_ALIGNMENT_LENGTH: 10000
MIN_QUERY_LENGTH: 50000

PREFIX: <prefix>

OUTDIR: /path/to/outdir
```

- GENOME: path to the genome fasta file (can be compressed). This is the genome that you want to be compared to all the others
- COMPARISON_GENOME: genome for whole genome comparison. Add your species name and the path to the fasta file. ex: chicken: /path/to/chicken.fna.gz. You can add several genomes, one on each line.
- MIN_ALIGNMENT_LENGTH and MIN_QUERY_LENGTH - parameters for plotting. If your plot is coming out blank or if there's an error with the plotting step, try lowering these thresholds. This happens because the alignments are not large enough.
- PREFIX: name of your species (ex: turkey)
- OUTDIR: directory where snakemake will run and where the results will be written to

If you want the results to be written to this directory (not to a new directory), comment out or remove
```
OUTDIR: /path/to/outdir
```

## ADDITIONAL SET UP
### Installing R packages 

First load R: 
```module load R/4.0.2```

Enter the R environment by writing `R` and clicking enter. Install the packages:
```
list.of.packages <- c("optparse", "data.table", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
```

If you get an error like this:
```
Warning in install.packages(new.packages) :
'lib = "/cm/shared/apps/R/3.6.2/lib64/R/library"' is not writable
```
Follow the instructions on how to install R packages locally [here](https://wiki.anunna.wur.nl/index.php/Installing_R_packages_locally) and try to install the packages again.

## RESULTS

The most important files and directories are:  

- **<run_date>_files.txt** dated file with an overview of the files used to run the pipeline (for documentation purposes)
- **genome_alignment/{prefix}_vs_{species}.paf** paf format file with the alignment. One for each comparison
- **genome_alignment/{prefix}_{species}.png** alignment with plot. One for each comparison
