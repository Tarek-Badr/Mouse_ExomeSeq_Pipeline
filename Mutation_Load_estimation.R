install.packages("BiocManager")
BiocManager::install("decompTumor2Sig")
BiocManager::install("BSgenome.Mmusculus.UCSC.mm10")
install.packages("g3viz", repos = "http://cran.us.r-project.org")
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("MutationalPatterns")
library(BSgenome)
head(available.genomes())

BiocManager::install("BSgenome.Mmusculus.UCSC.mm10")


ref_genome <- "BSgenome.Mmusculus.UCSC.mm10"
library(ref_genome, character.only = TRUE)


path <- "C:/Users/Lenovo R2G/Desktop/0-Mutec_Analysis/2020/VCF_new"
vcf_files = list.files(path,  pattern = ".vcf", full.names = TRUE)

sample_names <- c("CAD_1", "CAD_2", "CAD_3","CAD_4", "Ctrl_1", "Ctrl_2", "Ctrl_3", "Ctrl_4", "Ctrl_5", "Ctrl_6")

vcfs <- read_vcfs_as_granges(vcf_files, sample_names, ref_genome)
summary(vcfs)

genotype <- c(rep("CAD", 4), rep("Ctrl", 6))

muts = mutations_from_vcf(vcfs[[1]])

head(muts, 12)

types = mut_type(vcfs[[1]])

head(types, 12)

context = mut_context(vcfs[[1]], ref_genome)

head(context, 12)


type_context = type_context(vcfs[[1]], ref_genome)

lapply(type_context, head, 12)

type_occurrences <- mut_type_occurrences(vcfs, ref_genome)

type_occurrences

p1 <- plot_spectrum(type_occurrences)

p2 <- plot_spectrum(type_occurrences, CT = TRUE)

p3 <- plot_spectrum(type_occurrences, CT = TRUE, legend = FALSE)

library("gridExtra")

grid.arrange(p1, p2, p3, ncol=3, widths=c(3,3,1.75))

p4 <- plot_spectrum(type_occurrences, by = genotype, CT = TRUE, legend = TRUE)

p4

palette <- c("pink", "orange", "blue", "lightblue", "green", "red", "purple")

p5 <- plot_spectrum(type_occurrences, CT=TRUE, legend=TRUE, colors=palette)

grid.arrange(p4, p5, ncol=2, widths=c(4,2.3))

mut_mat <- mut_matrix(vcf_list = vcfs, ref_genome = ref_genome)

head(mut_mat)

plot_96_profile(mut_mat[,c(1,7)])

write.csv(mut_mat, file = "mut_mat.csv")
write.csv(type_occurrences, file = "type_occurrences.csv")

profile = plot_96_profile(mut_mat, condensed = TRUE)

mut_mat <- mut_mat + 0.0001

 library("NMF")

 estimate <- nmf(mut_mat, rank=2:5, method="brunet", nrun=10, seed=123456)

  plot(estimate)

nmf_res <- extract_signatures(mut_mat, rank = 2, nrun = 10)

colnames(nmf_res$signatures) <- c("Signature A", "Signature B")

rownames(nmf_res$contribution) <- c("Signature A", "Signature B")

pc_pc = plot_96_profile(nmf_res$signatures, condensed = TRUE)

  
pc1 <- plot_contribution(nmf_res$contribution, nmf_res$signature)

pc2 <- plot_contribution(nmf_res$contribution, nmf_res$signature, mode = "absolute")

Combine the two plots:
  
grid.arrange(pc1, pc2)

(pc1/pc2) | pc_pc

pch1 <- plot_contribution_heatmap(nmf_res$contribution, sig_order = c("Signature B", "Signature A"))

pch2 <- plot_contribution_heatmap(nmf_res$contribution, cluster_samples=FALSE)

grid.arrange(pch1, pch2, ncol = 2, widths = c(2,1.6))


plot_compare_profiles(mut_mat[,1], nmf_res$reconstructed[,1], profile_names = c("Original", "Reconstructed"), condensed = TRUE)

sp_url <- paste("https://cancer.sanger.ac.uk/cancergenome/assets/", "signatures_probabilities.txt", sep = "")

cancer_signatures = read.table(sp_url, sep = "\t", header = TRUE)

new_order = match(row.names(mut_mat), cancer_signatures$Somatic.Mutation.Type)

cancer_signatures = cancer_signatures[as.vector(new_order),]

row.names(cancer_signatures) = cancer_signatures$Somatic.Mutation.Type

cancer_signatures = as.matrix(cancer_signatures[,4:33])

plot_96_profile(cancer_signatures[,1:2], condensed = TRUE, ymax = 0.3)

hclust_cosmic = cluster_signatures(cancer_signatures, method = "average")

cosmic_order = colnames(cancer_signatures)[hclust_cosmic$order]

plot(hclust_cosmic)

cos_sim(mut_mat[,1], cancer_signatures[,1])

#Calculate pairwise cosine similarity between mutational profiles and COSMIC signatures:

cos_sim_samples_signatures = cos_sim_matrix(mut_mat, cancer_signatures)

plot_cosine_heatmap(cos_sim_samples_signatures, col_order = cosmic_order, cluster_rows = TRUE)

fit_res <- fit_to_signatures(mut_mat, cancer_signatures)

select <- which(rowSums(fit_res$contribution) > 10)

plot_contribution(fit_res$contribution[select,], cancer_signatures[,select], coord_flip = FALSE, mode = "absolute")

plot_contribution_heatmap(fit_res$contribution, cluster_samples = TRUE, method = "complete")




######################################################
Strand bias analyses
#####################################################





BiocManager::install("TxDb.Mmusculus.UCSC.mm10.knownGene")

library("TxDb.Mmusculus.UCSC.mm10.knownGene")

genes_mm10 <- genes(TxDb.Mmusculus.UCSC.mm10.knownGene)

genes_mm10

strand = mut_strand(vcfs[[1]], genes_mm10)
head(strand,10)

mut_mat_s <- mut_matrix_stranded(vcfs, ref_genome, genes_mm10)
mut_mat_s[1:5,1:5]

strand_counts <- strand_occurrences(mut_mat_s, by=genotype)
head(strand_counts)
strand_bias <- strand_bias_test(strand_counts)
strand_bias

ps1 <- plot_strand(strand_counts, mode = "relative")

ps2 <- plot_strand_bias(strand_bias)

ps1 + ps2


#signatures with strand bias

nmf_res_strand <- extract_signatures(mut_mat_s, rank = 2)

colnames(nmf_res_strand$signatures) <- c("Signature B", "Signature A")

a <- plot_192_profile(nmf_res_strand$signatures, condensed = TRUE)

b <- plot_signature_strand_bias(nmf_res_strand$signatures)

a + b



> # Define autosomal chromosomes

chromosomes <- seqnames(get(ref_genome))[1:22]

 # Make a rainfall plot

rain_1=  plot_rainfall(vcfs[[1]], title = names(vcfs[1]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)


rain_2=  plot_rainfall(vcfs[[2]], title = names(vcfs[2]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_3=  plot_rainfall(vcfs[[3]], title = names(vcfs[3]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)
rain_4=  plot_rainfall(vcfs[[4]], title = names(vcfs[4]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_5 =  plot_rainfall(vcfs[[5]], title = names(vcfs[5]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_6 =  plot_rainfall(vcfs[[6]], title = names(vcfs[6]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_7 =  plot_rainfall(vcfs[[7]], title = names(vcfs[7]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_8 =  plot_rainfall(vcfs[[8]], title = names(vcfs[8]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_9 =  plot_rainfall(vcfs[[9]], title = names(vcfs[9]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_10 =  plot_rainfall(vcfs[[10]], title = names(vcfs[10]),chromosomes = chromosomes, cex = 1.5, ylim = 1e+09)

rain_5 / rain_6 / rain_7 /rain_8 / rain_9 /rain_10

###########
library(biomaRt)
listMarts()

listDatasets(useEnsembl(biomart = "regulation"))

regulatory <- useEnsembl(biomart="regulation", dataset="mmusculus_regulatory_feature")

CTCF <- getBM(attributes = c('chromosome_name','chromosome_start','chromosome_end','feature_type_name'), filters = "regulatory_feature_type_name", values = "CTCF Binding Site", mart = regulatory)

CTCF_g <- reduce(GRanges(CTCF$chromosome_name, IRanges(CTCF$chromosome_start, CTCF$chromosome_end)))

promoter = getBM(attributes = c('chromosome_name', 'chromosome_start', 'chromosome_end', 'feature_type_name'), filters = "regulatory_feature_type_name", values = "Promoter", mart = regulatory)

promoter_g = reduce(GRanges(promoter$chromosome_name, IRanges(promoter$chromosome_start, promoter$chromosome_end)))

flanking = getBM(attributes = c('chromosome_name', 'chromosome_start', 'chromosome_end','feature_type_name'), filters = "regulatory_feature_type_name", values = "Promoter Flanking Region", mart = regulatory)

flanking_g = reduce(GRanges(flanking$chromosome_name, IRanges(flanking$chromosome_start, flanking$chromosome_end)))

regions <- GRangesList(promoter_g, flanking_g, CTCF_g)

names(regions) <- c("Promoter", "Promoter flanking", "CTCF")

seqlevelsStyle(regions) <- "UCSC"

surveyed_file <- "C:/Users/Lenovo R2G/Desktop/0-Mutec_Analysis/2020/ex_region_sort.bed"

library(rtracklayer)

surveyed <- import(surveyed_file)

seqlevelsStyle(surveyed) <- "UCSC"


surveyed_list <- rep(list(surveyed), 10)

distr <- genomic_distribution(vcfs, surveyed_list, regions)

distr_test <- enrichment_depletion_test(distr, by = genotype)

head(distr_test)

plot_enrichment_depletion(distr_test)
