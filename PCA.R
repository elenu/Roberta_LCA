setwd("~/Desktop/Trab_Elena/Roberta_LCA")

library(readxl)
Simulate_Human_Cravings_Analysis <- read_excel("Desktop/Trab_Elena/Roberta_LCA/Simulate Human Cravings Analysis.xlsx", 
                                               skip = 9)

df <- Simulate_Human_Cravings_Analysis[1:16,]
df[,-1] <- apply(df[,-1], 2, as.numeric)
rownames(df) <- df$...1

my_col <- data.frame(colnames(df[,-1]))
my_col$groups <- c(sample('Tri_1', 10, replace = T), sample('Tri_2',10, replace = T))

library("FactoMineR")
res.pca <- PCA(df[,-1], graph = FALSE)
res.pca$var$names <- df$...1

library("factoextra")
eig.val <- get_eigenvalue(res.pca)
eig.val
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 75)) # we have the 80% of the info in the top-5 PCs

var <- get_pca_var(res.pca)
var
# Coordinates
head(var$coord)
# Cos2: quality on the factore map
head(var$cos2)
# Contributions to the principal components
head(var$contrib)
# Coordinates of variables
head(var$coord, 4)
fviz_pca_var(res.pca, col.var = "black")

library("corrplot")
corrplot(var$cos2, is.corr=FALSE)
ind <- get_pca_ind(res.pca)
rownames(ind$cos2) <- df$...1
corrplot(ind$cos2, is.corr=FALSE)

# Total cos2 of variables on Dim.1 and Dim.2
fviz_cos2(res.pca, choice = "var", axes = 1:2)

# Color by cos2 values: quality on the factor map
fviz_pca_var(res.pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE # Avoid text overlapping
)


library("corrplot")
corrplot(var$contrib, is.corr=FALSE)    # to highlight the most contributing variables for each dimension
# Contributions of variables to PC1
fviz_contrib(res.pca, choice = "var", axes = 1, top = 10)
# Contributions of variables to PC2
fviz_contrib(res.pca, choice = "var", axes = 2, top = 10)
# Contribution of variables to both: PC1 and PC2
fviz_contrib(res.pca, choice = "var", axes = 1:2, top = 10)

fviz_pca_var(res.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)
fviz_pca_ind(res.pca,
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)


grp <- as.factor(my_col$groups)
# Color variables by groups
fviz_pca_var(res.pca, col.var = grp, 
             palette = c("#0073C2FF", "#EFC000FF", "#868686FF"),
             legend.title = "Cluster")


# The variable Species (index = 5) is removed
# before PCA analysis
iris.pca <- PCA(df[,-1], graph = FALSE)
fviz_pca_var(iris.pca,
             geom.var = "point", # show points only (nbut not "text")
             col.var = my_col$groups, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, # Concentration ellipses
             legend.title = "Groups"
)

fviz_pca_ind(iris.pca,
             geom.ind = "point", # show points only (nbut not "text")
             col.ind = "cos2", # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, # Concentration ellipses
             legend.title = "Groups"
)


ind.p <- fviz_pca_var(iris.pca, geom = "point", col.ind = my_col$groups)
ggpubr::ggpar(ind.p,
              title = "Principal Component Analysis",
              subtitle = "Iris data set",
              caption = "Source: factoextra",
              xlab = "PC1", ylab = "PC2",
              legend.title = "Species", legend.position = "top",
              ggtheme = theme_gray(), palette = "jco"
)
