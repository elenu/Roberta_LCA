setwd("~/Desktop/Trab_Elena/Roberta_LCA")

library(readxl)
Simulate_Human_Cravings_Analysis <- read_excel("Desktop/Trab_Elena/Roberta_LCA/Simulate Human Cravings Analysis.xlsx", 
                                               skip = 9)

pdf(file = "Data exploration by clustering analysis.pdf", width = 10, height = 10)
df <- Simulate_Human_Cravings_Analysis[1:16,]
df[,-1] <- apply(df[,-1], 2, as.numeric)
rownames(df) <- df$...1

my_col <- data.frame(colnames(df[,-1]))
my_col$groups <- c(sample('Tri_1', 10, replace = T), sample('Tri_2',10, replace = T))

library(pheatmap)
library(ggplot2)
library(RColorBrewer)

my_palette <- colorRampPalette(c("deepskyblue3", "white", "violetred2"))(n = 299)

matriu <- as.matrix(df[,-1])
rownames(matriu) <- df$...1 
pheatmap(as.matrix(matriu), 
         fontsize_row = 8, fontsize_col = 10, 
         scale = "row",#cellheight = 12,
         legend = T,
         main = "Scaled by rows.",color = my_palette,
         cellwidth = 20, 
         cluster_cols = T, cluster_rows = T,
         fontsize = 12)

annotation_col = as.data.frame(cbind(as.factor(my_col$groups),
                                     as.factor (my_col$groups))) # One advantage is that here you can define multiple side bars!
rownames(annotation_col) <- my_col$colnames.df....1.. # Make sure the names will match with your columns colnames(annotation_col) <- c('Stage', 'Age', 'Gender')
annotation_col$Patients <- rownames(annotation_col)
Patients <- rownames(annotation_col)

matriu <- matriu[,Patients]
ann_colors = list(Stage = c("khaki1", "gold", "sandybrown","red","wheat1"),
                  V1 = c("white","black"), V2=c("violet","royalblue3"), Clusters = c("red", "green", "blue"))
pheatmap(matriu,
         color = my_palette, annotation_colors = ann_colors, # Colors
         cellwidth = 10, width =8, height = 10,
         fontsize = 12,fontsize_row = 8, fontsize_col = 4, # Text size
         show_rownames = TRUE, labels_row = rownames(matriu),
         show_colnames = TRUE,labels_col = annotation_col$Patients,annotation_col = annotation_col[,-3], 
         legend = TRUE, border_color = NA, drop_levels = TRUE, # Legend's characteristics
         main = "Pheatmap scaled by rows", # Title
         scale = "row", # Scaling (could be also by "column")
         cluster_rows= TRUE, cluster_cols = FALSE) 
pheatmap(matriu,
         color = my_palette, annotation_colors = ann_colors, # Colors
         cellwidth = 10, width =8, height = 10,
         fontsize = 12,fontsize_row = 8, fontsize_col = 4, # Text size
         show_rownames = TRUE, labels_row = rownames(matriu),
         show_colnames = TRUE,labels_col = annotation_col$Patients,annotation_col = annotation_col[,-3], 
         legend = TRUE, border_color = NA, drop_levels = TRUE, # Legend's characteristics
         main = "Pheatmap scaled by rows", # Title
         scale = "row", # Scaling (could be also by "column")
         cluster_rows= TRUE, cluster_cols = TRUE) 
pheatmap(matriu,
         color = my_palette, annotation_colors = ann_colors, # Colors
         cellwidth = 10, width =8, height = 10,
         fontsize = 12,fontsize_row = 8, fontsize_col = 4, # Text size
         show_rownames = TRUE, labels_row = rownames(matriu),
         show_colnames = TRUE,labels_col = annotation_col$Patients,annotation_col = annotation_col[,-3], 
         legend = TRUE, border_color = NA, drop_levels = TRUE, # Legend's characteristics
         main = "Pheatmap scaled by columns", # Title
         scale = "column", # Scaling (could be also by "column")
         cluster_rows= TRUE, cluster_cols = TRUE) 
pheatmap(matriu,
         color = my_palette, annotation_colors = ann_colors, # Colors
         cellwidth = 10, width =8, height = 10,
         fontsize = 12,fontsize_row = 8, fontsize_col = 4, # Text size
         show_rownames = TRUE, labels_row = rownames(matriu),
         show_colnames = TRUE,labels_col = annotation_col$Patients,annotation_col = annotation_col[,-3], 
         legend = TRUE, border_color = NA, drop_levels = TRUE, # Legend's characteristics
         main = "Pheatmap not scaled", # Title
         scale = "none", # Scaling (could be also by "column")
         cluster_rows= TRUE, cluster_cols = TRUE) 
dev.off()

