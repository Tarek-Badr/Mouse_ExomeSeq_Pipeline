#!/bin/bash

sampleID="AA-18-30"
tmpdir="/home/tarek/Desktop/wxs/Tools/tmp"
bwamem= "/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwa mem"
bwaIndex="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx"
picard="java -Xmx30g -jar /home/tarek/Desktop/wxs/Tools/picard.jar"
GATK="/home/tarek/Desktop/wxs/Tools/gatk-4.0.12.0/gatk"
indelMills="/home/tarek/Desktop/wxs/Tools/mm10.indel.vcf"
dbsnp="/home/tarek/Desktop/wxs/Tools/mm10.snps.vcf"
mm10="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx.fa"
bedfile="/home/tarek/Desktop/wxs/ex_region.sort.bed"

# calling the variants using MUtec2
#the script for generating the mouse af only germline resource can be found in this folder in the script create_wdl.pl

${GATK} Mutect2 \
-R ${mm10} \
-I ${sampleID}-T.recal.bam \
-tumor ${sampleID}-T \
-I ${sampleID}-NM.recal.bam \
-normal ${sampleID}-NM \
-pon mwxs_pon.vcf \
--germline-resource mm10.v6.afonlygnomad.PASS.vcf \
-L ${bedfile}  \
-O ${sampleID}_mutec2.vcf \
-bamout ${sampleID}_Mutec2.bam
