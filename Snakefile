configfile: "config.yaml"
from snakemake.utils import makedirs
pipeline = "whole-genome-alignment" # replace with your pipeline's name


include: "rules/create_file_log.smk"
if "OUTDIR" in config:
    workdir: config["OUTDIR"]
makedirs("logs_slurm")

TARGET = config["GENOME"]
PREFIX = config["PREFIX"]
comp_genome_results = expand("genome_alignment/{prefix}_{species}.png", prefix=PREFIX, species = config["COMPARISON_GENOME"].keys())
MIN_ALIGNMENT_LENGTH = config["MIN_ALIGNMENT_LENGTH"]
MIN_QUERY_LENGTH = config["MIN_QUERY_LENGTH"]

def get_comparison_path(wildcards):
    '''
    Get genome path for comparison species
    '''
    return(config["COMPARISON_GENOME"][wildcards.species])


rule all:
    input:
        files_log,
        comp_genome_results        

rule align_genomes:
    input:
        assembly = TARGET,
        comparison = get_comparison_path
    output:
        "genome_alignment/{prefix}_vs_{species}.paf"
    message:
        'Rule {rule} processing'
    group:
        'genome_alignment'
    shell:
        """
minimap2 -t 12 -cx asm5 {input.comparison} {input.assembly} > {output}
        """

rule plot_aligned_genomes:
    input:
        rules.align_genomes.output
    output:
        "genome_alignment/{prefix}_{species}.png"
    message:
        'Rule {rule} processing'
    params:
        script = os.path.join(workflow.basedir, "scripts/pafCoordsDotPlotly.R"),
        min_alignment_length = MIN_ALIGNMENT_LENGTH,
        min_query_length = MIN_QUERY_LENGTH, 
        outdir = "genome_alignment/"
    group:
        'genome_alignment'
    shell:
        """
module load R/4.0.2
Rscript {params.script} -i {input} -o {wildcards.prefix}_{wildcards.species} -s -t -x -m {params.min_alignment_length} -q {params.min_query_length} -l
mv {wildcards.prefix}_{wildcards.species}.png {params.outdir}
        """
