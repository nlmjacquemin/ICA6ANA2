#!/bin/bash

PATH_TO_JOB_LOG_DIR=$1

cd /data

day=`date +%F`
hour=`date +%T`

input="raw"

output="result"

picrust2_pipeline.py \
	--stratified --per_sequence_contrib \
	-s $input/ASV.fna \
	-i $input/abd_uncorrected.wide.tsv \
	-o $output \
	-p $SLURM_CPUS_PER_TASK \
	--verbose \
	2>&1 | tee $PATH_TO_JOB_LOG_DIR/log_picrust_${day}_$hour.txt

# Adding description

#EC
add_descriptions.py -i $output/EC_metagenome_out/pred_metagenome_unstrat.tsv.gz -m EC -o $output/EC_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz

#KO
add_descriptions.py -i $output/KO_metagenome_out/pred_metagenome_unstrat.tsv.gz -m KO -o $output/KO_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz

#METACYC

add_descriptions.py -i $output/pathways_out/path_abun_unstrat.tsv.gz -m METACYC -o $output/pathways_out/path_abun_unstrat_descrip.tsv.gz


