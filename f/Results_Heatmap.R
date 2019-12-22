#A simple r script used to plot the plot the specific genes of interest in different samples
# Various data filtering methods are mentioned in previous codes.

#Upload a txt file having number of mutations per gene in each sample
wxs = read.delim("wxs_genes_ordered.txt",sep='\t',row.names = 1)
wxs

#normalization (as samples size < 30, rld is prefered than vst)
install.packages("pheatmap", dependencies=TRUE)
install.packages("RColorBrewer", dependencies=TRUE)
library("pheatmap")
library("RColorBrewer")

pheatmap(wxs, fontsize_number = 2 * fontsize,
         cellwidth = 15, cellheight = 12, scale = "none",
         treeheight_row = 100,
         kmeans_k = NA,
         show_rownames = T, show_colnames = T,
         main = "Full heatmap (avg, eucl, unsc)",
         clustering_method = "average",
         cluster_rows = FALSE, cluster_cols = FALSE,
         clustering_distance_rows = drows1, 
         clustering_distance_cols = dcols1) 

#the following function credit goes to the davetang blog
cal_z_score <- function(x){
  (x - mean(x)) / sd(x)
}

wxs_norm <- t(apply(wxs, 1, cal_z_score))

pheatmap(wxs_norm, fontsize_number = 2 * fontsize,
         cellwidth = 15, cellheight = 12, scale = "none",
         treeheight_row = 100,
         kmeans_k = NA,
         show_rownames = T, show_colnames = T,
         main = "Full heatmap (avg, eucl, unsc)",
         clustering_method = "average",
         cluster_rows = FALSE, cluster_cols = FALSE,
         clustering_distance_rows = drows1, 
         clustering_distance_cols = dcols1) 
