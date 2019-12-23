#!/bin/bash

sampleID="AA-18-31-T"
sample="/home/tarek/Desktop/wxs/Cleanseqs/${sampleID}"
tmpdir="/home/tarek/Desktop/wxs/Tools/tmp"
bwamem= "/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwa mem"
bwaIndex="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx"
picard="java -Xmx30g -jar /home/tarek/Desktop/wxs/Tools/picard.jar"
GATK="/home/tarek/Desktop/wxs/Tools/gatk-4.0.12.0/gatk"
indelMills="/home/tarek/Desktop/wxs/Tools/mm10.indel.vcf"
dbsnp="/home/tarek/Desktop/wxs/Tools/mm10.snps.vcf"
mm10="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx.fa"
bedfile="/home/tarek/Desktop/wxs/ex_region.sort.bed"

${bwamem} \
-t 10 \
-M \
-R "@RG\tID:${sampleID}\tLB:NEXTERA\tPL:ILLUMINA\tSM:${sampleID}" \ 
${bwaIndex} \
${sample}_1.fq.gz \ 
${sample}_2.fq.gz > \
${sampleID}.sam

${picard} SortSam \
SO=coordinate \
INPUT=${sampleID}.sam \
OUTPUT=${sampleID}.bam \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true

#rm ${sampleID}.sam 

${picard} MarkDuplicates \
INPUT=${sampleID}.bam \
OUTPUT=${sampleID}.dedup.bam \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true \
METRICS_FILE=${sampleID}.metrics.txt \
TMP_DIR=${tmpdir}

${GATK} BaseRecalibrator \
-R ${mm10} \
-L ${bedfile}  \
-I ${sampleID}.dedup.bam \
--known-sites ${dbsnp} \
--known-sites ${indelMills} \
-O ${sampleID}.recal.data.table

mv ${sampleID}.recal.data.table ${sampleID}.grp

${GATK} ApplyBQSR \
-bqsr ${sampleID}.grp \
-I ${sampleID}.dedup.bam \
-O ${sampleID}.recal.bam

#rm ${sampleID}.recal_data.grp ${sampleID}.realigned.bam ${sampleID}.realigned.bai
