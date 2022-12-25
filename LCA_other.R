### LCA.R
setwd("~/Desktop/Trab_Elena/Roberta_LCA")

library(readxl)
Simulate_Human_Cravings_Analysis <- read_excel("Simulate Human Cravings Analysis.xlsx", 
                                               skip = 9)

df <- Simulate_Human_Cravings_Analysis[1:16,]
df[,-1] <- apply(df[,-1], 2, as.numeric)
rownames(df) <- df$...1

my_col <- data.frame(colnames(df[,-1]))
my_col$groups <- c(sample('Tri_1', 10, replace = T), sample('Tri_2',10, replace = T))

women <- as.data.frame(t(df))
women <- women[-1,]
women$Patients <- rownames(women)
women2 <- left_join(my_col, women, 'Patients')
rownames(women2) <- women2$Patients
women2 <- women2[,-1]

# these are the defaults of the poLCA command
colnames(df) <- c('Food', 'W1_1', 'W2_1', 'W3_1', 'W4_1', 'W5_1', 'W6_1', 'W7_1', 'W8_1', 'W9_1', 'W10_1', 
                  'W1_2', 'W2_2', 'W3_2', 'W4_2', 'W5_2', 'W6_2', 'W7_2', 'W8_2', 'W9_2', 'W10_2')
# select variables
mydata <- df %>% dplyr::select('W1_1', 'W2_1', 'W3_1', 'W4_1', 'W5_1', 'W6_1', 'W7_1', 'W8_1', 'W9_1', 'W10_1', 
                               'W1_2', 'W2_2', 'W3_2', 'W4_2', 'W5_2', 'W6_2', 'W7_2', 'W8_2', 'W9_2', 'W10_2')
# define function
f<-with(mydata, cbind(W1_1, W2_1, W3_1, W4_1, W5_1, W6_1, W7_1, W8_1, W9_1, W10_1, 
                      W1_2, W2_2, W3_2, W4_2, W5_2, W6_2, W7_2, W8_2, W9_2, W10_2)~1) #
library(poLCA)

LCA2 <- poLCA(f, data=mydata, nclass=2)

plot(LCA2)

LCA3 <- poLCA(f, data=mydata, nclass=3)
plot(LCA3)

LCA3 <- poLCA(f, data=mydata, nclass=3, maxiter=3000)
plot(LCA3)

LCA3 <- poLCA(f, data=mydata, nclass=3, nrep=5)
plot(LCA3)

LCA3 <- poLCA(f, data=mydata, nclass=3, maxiter=3000, nrep=5)
plot(LCA3)

LCA4 <- poLCA(f, data=mydata, nclass=4, maxiter=3000, nrep=5)
plot(LCA4)
#LCA4 <- poLCA(f1, data=mydata, nclass=4, maxiter=5000, nrep=5)

LCA5 <- poLCA(f, data=mydata, nclass=5, maxiter=5000, nrep=10)

