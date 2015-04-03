#!/bin/bash

# aux script to convert list of sam files to sorted and indexed bam files
# usage: bash sam_to_indexed_bam.sh sam1.sam sam2.sam ...
# NOTE: each sam file should have ending ".sam"

for SAM in $*
do
    BAM=${SAM%%.sam}.bam
    samtools view -bS $SAM > $BAM
    samtools sort $BAM temp_bam_sorted
    mv temp_bam_sorted.bam $BAM
    samtools index $BAM
done
