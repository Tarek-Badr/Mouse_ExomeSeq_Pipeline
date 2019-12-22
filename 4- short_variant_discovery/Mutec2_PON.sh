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

# we need to create a panel of normals that can help Mutec2 better detect somatic mutations
# Run Mutect2 in tumor-only mode for each normal sample

${GATK} Mutect2 \
-R ${mm10} \
-I {sample}.recal.bam -tumor {sample} \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-L ${bedfile} \
-O {sample}.vcf

# now we combine the normal vcf files to create a panel of normals (you add all your normal tissue from your samples
# using the -vcfs 
${GATK} CreateSomaticPanelOfNormals -vcfs {sample}.vcf -vcfs {sample}.vcf -vcfs {sample}.vcf -O mwxs_pon.vcf
 
