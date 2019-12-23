##### Copyright Yask Gupta and Tarek Zakaria, Date: 8 Oct 2019 #####
### University of Luebeck and University of Freiberg Germany #####
### This script generate a mouse sites-only vcf where the only INFO field is allele frequency (AF) required by Mutec2

# Download the Mouse strain vcf file from ftp://ftp-mouse.sanger.ac.uk/REL-1807-SNPs_Indels/mgp.v6.merged.norm.snp.indels.sfiltered.vcf.gz

# The following script depends upon vcftools and work only in linux 

# Create file mgp.v6.merged.norm.snp.indels.sfiltered.fields.txt using command: gunzip -c mgp.v6.merged.norm.snp.indels.sfiltered.vcf.gz | awk -F '\t' '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' > mgp.v6.merged.norm.snp.indels.sfiltered.fields.txt

# Create the file mgp.frq.count using command: vcftools --gzvcf mgp.v6.merged.norm.snp.indels.sfiltered.vcf.gz --counts --out mgp

# WARNING; All the file should be in same folder where you are running script 
# Run the script using command: perl create_wdl.pl > mgp.v6.merged.norm.snp.indels.sfiltered.wdl
# If just PASS filtered data is needed then use one more command: grep "\#\|PASS" mgp.v6.merged.norm.snp.indels.sfiltered.wdl > mgp.v6.merged.norm.snp.indels.sfiltered.PASS.wdl

use strict;
use warnings;
my %mpgData;
open FILE,"mgp.v6.merged.norm.snp.indels.sfiltered.fields.txt" or die $!;
while(<FILE>){
	chomp $_;
	if($_!~/^#/){
		my @arTmp = split("\t",$_);
		$mpgData{$arTmp[0]}{$arTmp[1]}{$arTmp[3]}{$arTmp[4]} = $_;
	}
}
close FILE;

print "\#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n";
open FILE,"mgp.frq.count" or die $!;
while(<FILE>){
	chomp $_;
	if($_!~/^CHROM/){
		my @arTmp = split("\t",$_);
		my $chrom = $arTmp[0];
		my $pos = $arTmp[1];
		my $tot = $arTmp[3];
		my $ref = (split ":", $arTmp[4])[0];
		my @alt; my @ac; my @af;
		for(my $i=5;$i<scalar(@arTmp);$i++){
			my($al,$ct) = split(":",$arTmp[$i]);
			push(@alt,$al);
			push(@ac,$ct);
			my $afm;
			if($ct/$tot < 0.001){
				$afm = uc(sprintf("%e",$ct/$tot));
			}else{
				$afm = sprintf("%.5f",$ct/$tot);
			}
			push(@af,$afm);
		}
		my $altf = join(",",@alt);
		my $acf = join(",",@ac);
		my $aff = join(",",@af);
		if(exists($mpgData{$chrom}{$pos}{$ref}{$altf})){
			print $mpgData{$chrom}{$pos}{$ref}{$altf}."\t"."AC=".$acf.";"."AF=".$aff."\n";
		}else{
			print STDERR "problem with the line".$_."\n";
		}
	}
}
close FILE;



