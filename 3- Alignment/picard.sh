#!/bin/bash

sampleID=$1
mkdir --parents scratchtarek${sampleID}
mkdir --parents scratchtarek${sampleID}tmp
tmpdir=scratchtarek${sampleID}tmp
GATK= /home/tarek/Desktop/wxs/Tools/gatk-4.0.12.0/gatk 
picard=java -Xmx30g -jar /home/tarek/Desktop/wxs/Tools/picard.jar
bwaIndex=/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx
mm10=/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx.fa
bedfile=/home/tarek/Desktop/wxs/ex_region.sort.bed
indelMills=/home/tarek/Desktop/wxs/Tools/mm10.indel.vcf
dbsnp=/home/tarek/Desktop/wxs/Tools/mm10.snps.vcf
bwamem=/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwa mem

${picard} SortSam SO=coordinate INPUT=${sample}.sam  OUTPUT=${sample}.bam VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true

rm ${sample}.sam

${picard} MarkDuplicates INPUT=${sample}.bam OUTPUT=${sample}.dedup.bam VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true METRICS_FILE=${sample}.metrics.txt TMP_DIR=${tmpdir}

rm ${sample}.bam ${sample}.bai
