# **Refrences preparation**

The pipeline requires various refrences and resources to run properly.

## **Mouse Refrence Genome**

The mouse reference genome mm10/GRCm38 can be downloaded from 
[here](https://emea.support.illumina.com/sequencing/sequencing_software/igenome.html?langsel=/de/) 
or 
[here](http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/chromFa.tar.gz)

Using linux command line adjust the file using the following commands:

tar zvfx chromFa.tar.gz
cat *.fa > mm10.fa

### Refrence index

bwa index -p mm10bwaidx -a bwtsw mm10.fa

## **SNPs and Indels**

GATK requires a list of known sites (SNPs and Indels) to match against.
The used versions used in this analysis can be found 
[here](ftp://ftp-mouse.sanger.ac.uk/REL-1303-SNPs_Indels-GRCm38/).


**To format the SNP file to match the refrence use the following code**

grep "#" /PATH/mgp.v3.snps.rsIDdbSNPv137.vcf/mgp.v3.snps.rsIDdbSNPv137.vcf > mm10.snps.header
grep -v "#" /PATH/mgp.v3.snps.rsIDdbSNPv137.vcf/mgp.v3.snps.rsIDdbSNPv137.vcf | awk '{print "chr"$0}' > mm10.snps.data
cat mm10.snps.header mm10.snps.data > mm10.snps.vcf
gatk-4.0.12.0/gatk IndexFeatureFile -F mm10.snps.vcf 

**To format the indel file to match the refrence use the following code**

grep "#" /PATH/mgp.v3.indels.rsIDdbSNPv137.vcf > mm10.indel.header
grep -v "#" /PATH/mgp.v3.indels.rsIDdbSNPv137.vcf | awk '{print "chr"$0}' > mm10.indel.data
cat mm10.indel.header mm10.indel.data > mm10.indel.vcf
gatk-4.0.12.0/gatk IndexFeatureFile -F mm10.indel.vcf 

