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

# calling the variants using MUtec2

${GATK} Mutect2 \
-R ${mm10} \
-I {sample}.recal.bam -tumor {sample} \
-I {sample}.recal.bam -normal {sample} \
-pon mwxs_pon.vcf \
-L ${bedfile} \
-O {sample}.vcf \ 
-bamout {sample}.Mutec2.bam
