# Mouse_WES_Pipeline
A pipeline for calling somatic mutations from mouse whole exome sequence data

This documents describes a pipeline intended for Somatic short variant discovery (SNVs + Indels) from mouse whole exome tumor samples.
The pipeline should be optimized according to experimental design, infrastructure, and various consideration, but the wide frame
should be applicable in comparibale conditions.


Our data was generated using 100x whole exome sequencing of C57BL/6 normal and tumor tissue samples with DNA SureSelect XT Mouse All Exon Agilent kit on a Illumina Hiseq Xten to generate Paired-end sequences with read lengths of 150  base pairs each.  

This work flow was carried out on a Dell Mobile workstation Precision 7530 CTO Basis, with Intel Xeon E-2186M Prozessor, 6 cores, and 64GB, and it takes around a day to analyze 8 to 10 exomes.

All analysis is carried out on Ubuntu Linux 16.04.

The workflow is organized in the following manner:

1- Requiered software installation

2- Preparation of required refrence genomes and germline resources

3- Data processing up until analysis ready bams

4- Variant Calling using Mutec2 and varscan somatic

5- Genetic variants annotation and data filtering 
