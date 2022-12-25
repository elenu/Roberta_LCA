#install.packages('poLCA')

library("reshape2")
library("plyr")
library("dplyr")
library("poLCA")
library("ggplot2")
library("ggparallel")
library("igraph")
library("tidyr")
library("knitr")

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


lc2 <- poLCA(f,mydata,nclass=2, calc.se=TRUE)

#------ run a sequence of models with 1-10 classes and print out the model with the lowest BIC ----
max_II <- -100000
min_bic <- 100000
mydata <- as.data.frame(apply(mydata,2,as.numeric))
for(i in 2:10){
  lc <- poLCA(f, mydata, nclass=i, maxiter=3000, 
              tol=1e-5, na.rm=FALSE,  
              nrep=10, verbose=TRUE, calc.se=TRUE)
  if(lc$bic < min_bic){
    min_bic <- lc$bic
    LCA_best_model<-lc
  }
}    	
LCA_best_model


## Generate table ----
#select data
mydata <- df %>% dplyr::select('W1_1', 'W2_1', 'W3_1', 'W4_1', 'W5_1', 'W6_1', 'W7_1', 'W8_1', 'W9_1', 'W10_1', 
                               'W1_2', 'W2_2', 'W3_2', 'W4_2', 'W5_2', 'W6_2', 'W7_2', 'W8_2', 'W9_2', 'W10_2')

# define function
f<-with(mydata, cbind(W1_1, W2_1, W3_1, W4_1, W5_1, W6_1, W7_1, W8_1, W9_1, W10_1, 
                      W1_2, W2_2, W3_2, W4_2, W5_2, W6_2, W7_2, W8_2, W9_2, W10_2)~1)

## models with different number of groups without covariates:
set.seed(01012)
lc1<-poLCA(f, data=mydata, nclass=1, na.rm = FALSE, nrep=30, maxiter=3000) #Loglinear independence model.
lc2<-poLCA(f, data=mydata, nclass=2, na.rm = FALSE, nrep=30, maxiter=3000)
lc3<-poLCA(f, data=mydata, nclass=3, na.rm = FALSE, nrep=30, maxiter=3000)
lc4<-poLCA(f, data=mydata, nclass=4, na.rm = FALSE, nrep=30, maxiter=3000) 
lc5<-poLCA(f, data=mydata, nclass=5, na.rm = FALSE, nrep=30, maxiter=3000)
lc6<-poLCA(f, data=mydata, nclass=6, na.rm = FALSE, nrep=30, maxiter=3000)
lc7<-poLCA(f, data=mydata, nclass=7, na.rm = FALSE, nrep=30, maxiter=3000)
lc8<-poLCA(f, data=mydata, nclass=8, na.rm = FALSE, nrep=30, maxiter=3000)

# generate dataframe with fit-values

results <- data.frame(Modell=c("Modell 1"),
                      log_likelihood=lc1$llik,
                      df = lc1$resid.df,
                      BIC=lc1$bic,
                      ABIC=  (-2*lc1$llik) + ((log((lc1$N + 2)/24)) * lc1$npar),
                      CAIC = (-2*lc1$llik) + lc1$npar * (1 + log(lc1$N)), 
                      likelihood_ratio=lc1$Gsq)
results$Modell<-as.integer(results$Modell)
results[1,1]<-c("Model 1")
results[2,1]<-c("Model 2")
results[3,1]<-c("Model 3")
results[4,1]<-c("Model 4")
results[5,1]<-c("Model 5")
results[6,1]<-c("Model 6")
results[7,1]<-c("Model 7")
results[8,1]<-c("Model 8")

results[2,2]<-lc2$llik
results[3,2]<-lc3$llik
results[4,2]<-lc4$llik
results[5,2]<-lc5$llik
results[6,2]<-lc6$llik
results[7,2]<-lc7$llik
results[8,2]<-lc8$llik

results[2,3]<-lc2$resid.df
results[3,3]<-lc3$resid.df
results[4,3]<-lc4$resid.df
results[5,3]<-lc5$resid.df
results[6,3]<-lc6$resid.df
results[7,3]<-lc7$resid.df
results[8,3]<-lc8$resid.df

results[2,4]<-lc2$bic
results[3,4]<-lc3$bic
results[4,4]<-lc4$bic
results[5,4]<-lc5$bic
results[6,4]<-lc6$bic
results[7,4]<-lc7$bic
results[8,4]<-lc8$bic

results[2,5]<-(-2*lc2$llik) + ((log((lc2$N + 2)/24)) * lc2$npar) #abic
results[3,5]<-(-2*lc3$llik) + ((log((lc3$N + 2)/24)) * lc3$npar)
results[4,5]<-(-2*lc4$llik) + ((log((lc4$N + 2)/24)) * lc4$npar)
results[5,5]<-(-2*lc5$llik) + ((log((lc5$N + 2)/24)) * lc5$npar)
results[6,5]<-(-2*lc6$llik) + ((log((lc6$N + 2)/24)) * lc6$npar)
results[7,5]<-(-2*lc7$llik) + ((log((lc7$N + 2)/24)) * lc7$npar)
results[8,5]<-(-2*lc8$llik) + ((log((lc8$N + 2)/24)) * lc8$npar)

results[2,6]<- (-2*lc2$llik) + lc2$npar * (1 + log(lc2$N)) #caic
results[3,6]<- (-2*lc3$llik) + lc3$npar * (1 + log(lc3$N))
results[4,6]<- (-2*lc4$llik) + lc4$npar * (1 + log(lc4$N))
results[5,6]<- (-2*lc5$llik) + lc5$npar * (1 + log(lc5$N))
results[6,6]<- (-2*lc6$llik) + lc6$npar * (1 + log(lc6$N))
results[7,6]<- (-2*lc7$llik) + lc7$npar * (1 + log(lc7$N))
results[8,6]<- (-2*lc8$llik) + lc8$npar * (1 + log(lc8$N))

results[2,7]<-lc2$Gsq
results[3,7]<-lc3$Gsq
results[4,7]<-lc4$Gsq
results[5,7]<-lc5$Gsq
results[6,7]<-lc6$Gsq
results[7,7]<-lc7$Gsq
results[8,7]<-lc8$Gsq

print(results)

# Calculation of the error: -----
entropy<-function (p) sum(-p*log(p))

results$R2_entropy
results[1,8]<-c("-")

error_prior<-entropy(lc2$P) # class proportions model 2
error_post<-mean(apply(lc2$posterior,1, entropy),na.rm = TRUE)
results[2,8]<-round(((error_prior-error_post) / error_prior),3)

error_prior<-entropy(lc3$P) # class proportions model 3
error_post<-mean(apply(lc3$posterior,1, entropy),na.rm = TRUE)
results[3,8]<-round(((error_prior-error_post) / error_prior),3)

error_prior<-entropy(lc4$P) # class proportions model 4
error_post<-mean(apply(lc4$posterior,1, entropy),na.rm = TRUE)
results[4,8]<-round(((error_prior-error_post) / error_prior),3)

error_prior<-entropy(lc5$P) # class proportions model 5
error_post<-mean(apply(lc5$posterior,1, entropy),na.rm = TRUE)
results[5,8]<-round(((error_prior-error_post) / error_prior),3)

error_prior<-entropy(lc6$P) # class proportions model 6
error_post<-mean(apply(lc6$posterior,1, entropy),na.rm = TRUE)
results[6,8]<-round(((error_prior-error_post) / error_prior),3)

error_prior<-entropy(lc7$P) # class proportions model 7
error_post<-mean(apply(lc7$posterior,1, entropy),na.rm = TRUE)
results[7,8]<-round(((error_prior-error_post) / error_prior),3)

error_prior<-entropy(lc8$P) # class proportions model 8
error_post<-mean(apply(lc8$posterior,1, entropy),na.rm = TRUE)
results[8,8]<-round(((error_prior-error_post) / error_prior),3)

# combining results to a dataframe
colnames(results)<-c("Model","log-likelihood","resid. df","BIC","aBIC","cAIC","likelihood-ratio","Entropy")
lca_results<-results

#Elbow plot -----
# plot 1

# Order categories of results$model in order of appearance
#install.packages("forcats")
library("forcats")
results$model < - as_factor(results$Model) 

#convert to long format
results2<-tidyr::gather(results,Kriterium,Guete,4:7)
results2

#plot
fit.plot<-ggplot(results2) + 
  geom_point(aes(x=Model,y=Guete),size=3) +
  geom_line(aes(Model, Guete, group = 1)) +
  theme_bw()+
  labs(x = "", y="", title = "") + 
  facet_grid(Kriterium ~. ,scales = "free") +
  theme_bw(base_size = 16, base_family = "") +   
  theme(panel.grid.major.x = element_blank() ,
        panel.grid.major.y = element_line(colour="grey", size=0.5),
        legend.title = element_text(size = 16, face = 'bold'),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 16),
        legend.text=  element_text(size=16),
        axis.line = element_line(colour = "black")) # Achsen etwas dicker

# save 650 x 800
pdf(file = "Elbow_plot_LCA.pdf", width = 10, height = 10)
fit.plot
dev.off()
## Inspect population shares of classes ----
#If you are interested in the population-shares of the classes, you can get them like this:
round(colMeans(lc$posterior)*100,2)
#[1] 6.25 12.50 12.50 12.50 12.50  6.25  6.25 12.50 12.50  6.25
#or you inspect the estimated class memberships:
table(lc$predclass)
#1  2  3  4  5  6  7  8  9 10 
#1  2  2  2  2  1  1  2  2  1 
round(prop.table(table(lc$predclass)),4)*100
#   1     2     3     4     5     6     7     8     9    10 
#6.25 12.50 12.50 12.50 12.50  6.25  6.25 12.50 12.50  6.25 

## Ordering of the latent classes ----
#extract starting values from our previous best model (with 2 classes)
probs.start<-lc2$probs.start

#re-run the model, this time with "graphs=TRUE"
lc<-poLCA(f, mydata, nclass=2, probs.start=probs.start,graphs=TRUE, na.rm=TRUE, maxiter=3000)

# If you don´t like the order, reorder them (here: Class 1 craver, Class 2 non craver)
new.probs.start<-poLCA.reorder(probs.start, c(1,2))

#run polca with adjusted ordering
lc<-poLCA(f, mydata, nclass=2, probs.start=new.probs.start,graphs=TRUE, na.rm=TRUE)
lc

# Plotting
lcmodel <- reshape2::melt(lc$probs, level=2)
zp1 <- ggplot(lcmodel,aes(x = L2, y = value, fill = Var2))
zp1 <- zp1 + geom_bar(stat = "identity", position = "stack")
zp1 <- zp1 + facet_grid(Var1 ~ .) + scale_y_continuous("Women", expand = c(0, 0))
zp1 <- zp1 + scale_fill_brewer(type="seq", palette="RdPu") +theme_bw()
zp1 <- zp1 + labs(x = "Women",y="Probability", fill ="Pr(Model)")
zp1 <- zp1 + theme( axis.text.y=element_blank(),
                    axis.ticks.y=element_blank(),                    
                    panel.grid.major.y=element_blank())
zp1 <- zp1 + guides(fill = guide_legend(reverse=TRUE))
print(zp1)

zp2 <- ggplot(lcmodel,aes(x = Var1, y = value, fill = Var2))
zp2 <- zp2 + geom_bar(stat = "identity", position = "stack")
zp2 <- zp2 + facet_wrap(~ L2)
zp2 <- zp2 + scale_x_discrete("Classes", expand = c(0, 0))
zp2 <- zp2 + scale_y_continuous("Probability", expand = c(0, 0))
zp2 <- zp2 + scale_fill_brewer(type="seq", palette="RdPu") +
  theme_bw()
zp2 <- zp2 + labs(fill ="Categories")
zp2 <- zp2 + theme( axis.text.y=element_blank(),
                    axis.ticks.y=element_blank(),                    
                    panel.grid.major.y=element_blank()#,
                    #legend.justification=c(1,0), 
                    #legend.position=c(1,0)
)
zp2 <- zp2 + guides(fill = guide_legend(reverse=TRUE))
zp2
pdf(file = "Adjusted_LCA.pdf", width = 10, height = 10)
zp1
zp2
dev.off()

write.table(lcmodel, "final model.txt", sep = "|", dec = ".", row.names = FALSE)
write.table(lc$probs, "Model_probs.txt", sep = "|", dec = ".", row.names = F)
