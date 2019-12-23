#!/bin/bash

sampleID="AA-18-31-T"
#sampleID=$1
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

# indel realignment is no longer necessary for variant discovery using Mutec2 or other haplotype assembly steps in newer GATK
#versions, therefore we only need the following steps before variant calling:  BaseRecalibrator, Apply Recalibration, AnalyzeCovariates (optional)

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

#Now you have Analysis ready BAM files for variant calling by Mutec2 or Varscan or samtools.
