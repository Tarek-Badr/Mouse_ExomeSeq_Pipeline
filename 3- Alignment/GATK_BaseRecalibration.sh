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

# indel realignment is no longer necessary for variant discovery using Mutec2 or other haplotype assembly steps in newer GATK
#versions, therefore we only need the following steps before variant calling:  BaseRecalibrator, Apply Recalibration, AnalyzeCovariates (optional)


${GATK} BaseRecalibrator -R ${mm10} -L ${bedfile} -I {sample}.dedup.bam \
--known-sites ${dbsnp} --known-sites ${indelMills} -O {sample}.recal.data.table

mv {sample}.recal.data.table {sample}.grp

${GATK} ApplyBQSR -bqsr {sample}.grp -I {sample}.dedup.bam -O {sample}.recal.bam 

#Now you have Analysis ready BAM files for variant calling by Mutec2 or Varscan or samtools.
