#!/bin/bash

sampleID="AA-18-31"
mm10="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx.fa"
bedfile="/home/tarek/Desktop/wxs/ex_region.sort.bed"
samtools="~/Desktop/wxs/Tools/samtools-1.9/samtools"
varscan="java -Xmx30g -jar /home/tarek/Desktop/wxs/Tools/VarScan.v2.3.9.jar"

#make pileup files from recaled BAM

${samtools} mpileup \
-B \
-q 1 \ 
-l ${bedfile} \
-f ${mm10} \
${sampleID}-NM.recal.bam > \
${sampleID}-NM.pileup  

${samtools} mpileup \
-B \
-q 1 \ 
-l ${bedfile} \
-f ${mm10} \
${sampleID}-T.recal.bam > \
${sampleID}-T.pileup  

#run varscan somatic on pileup files

${varscan} somatic \
${sampleID}-NM.pileup \
${sampleID}-T.pileup \
${sampleID}-varscan \
--min-coverage 10 \
--min-var-freq 0.08 \
--p-value 0.10 \
--somatic-p-value 0.05 \
--strand-filter 0 \
--output-vcf 1

${varscan} processSomatic ${sampleID}-varscan.snp.vcf
${varscan} processSomatic ${sampleID}-varscan.indel.vcf
