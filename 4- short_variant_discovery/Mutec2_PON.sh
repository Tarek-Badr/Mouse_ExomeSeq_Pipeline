#!/bin/bash

sampleID_1="AA-18-25-NM"
sampleID_2="AA-18-26-NM"
sampleID_3="AA-18-29-NM"
sampleID_4="AA-18-30-NM"
tmpdir="/home/tarek/Desktop/wxs/Tools/tmp"
bwamem= "/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwa mem"
bwaIndex="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx"
picard="java -Xmx30g -jar /home/tarek/Desktop/wxs/Tools/picard.jar"
GATK="/home/tarek/Desktop/wxs/Tools/gatk-4.0.12.0/gatk"
indelMills="/home/tarek/Desktop/wxs/Tools/mm10.indel.vcf"
dbsnp="/home/tarek/Desktop/wxs/Tools/mm10.snps.vcf"
mm10="/home/tarek/Desktop/wxs/Tools/bwa-0.7.17/bwamm10index/mm10bwaidx.fa"
bedfile="/home/tarek/Desktop/wxs/ex_region.sort.bed"

# we need to create a panel of normals that can help Mutec2 better detect somatic mutations
# Run Mutect2 in tumor-only mode for each normal sample

${GATK} Mutect2 \
-R ${mm10} \
-L ${bedfile}  \
-I ${sampleID_1}.recal.bam -tumor ${sampleID_1} \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-O ${sampleID_1}.vcf

${GATK} Mutect2 \
-R ${mm10} \
-L ${bedfile}  \
-I ${sampleID_2}.recal.bam -tumor ${sampleID_2} \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-O ${sampleID_2}.vcf

${GATK} Mutect2 \
-R ${mm10} \
-L ${bedfile}  \
-I ${sampleID_3}.recal.bam -tumor ${sampleID_3} \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-O ${sampleID_3}.vcf

${GATK} Mutect2 \
-R ${mm10} \
-L ${bedfile}  \
-I ${sampleID_4}.recal.bam -tumor ${sampleID_4} \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-O ${sampleID_4}.vcf

# now we combine the normal vcf files to create a panel of normals (you add all your normal tissue from your samples
# using the -vcfs 

${GATK} CreateSomaticPanelOfNormals -vcfs ${sampleID_1}.vcf -vcfs ${sampleID_2}.vcf -vcfs ${sampleID_3}.vcf -vcfs ${sampleID_4}.vcf -O mwxs_pon.vcf
 
