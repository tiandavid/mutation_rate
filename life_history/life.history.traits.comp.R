library(ggplot2)
library(ggpmisc)
library(readr)
library(dplyr)
library(patchwork)
library(scales) 
library(ape)
library(ggtree)
library(aplot)
library(data.table)
library(geiger)
library(nlme)
library(phytools)
library(caper)


#load data
data <- read_csv("final_bergeron_life_history_revision.csv")
data_no_DHP <- data[data$species_name != "Cyprinodon_diabolis", ]
highlight_individual <- "Cyprinodon_diabolis"  
is_hl <- grepl(highlight_individual, data$species_name, fixed = TRUE)

data <- data %>%
  mutate(group = case_when(
    is_hl ~ paste0("highlight", cumsum(is_hl)),
    taxonomic_group == "Fish" ~ "fish",
    TRUE ~ "other"
  ))


#generation time
plot1 <- ggplot(data, aes(x = generation_time, y = mutation_rate)) +
  geom_point(aes(color = group, shape = group, fill = group), size = 3) +
  geom_smooth(
    data = subset(data, !grepl("^highlight", group)),
    method = "lm", se = TRUE, color = "black", fullrange = TRUE
  ) +
  scale_color_manual(values = c(highlight1 = "red",
                                highlight2 = "red",
                                fish = "blue",
                                other = "black")) +
  scale_fill_manual(values = c(highlight1 = "red",
                               highlight2 = "red",
                               fish = "blue",
                               other = "black")) +
  scale_shape_manual(values = c(highlight1 = 24,
                                highlight2 = 25,
                                fish = 17,
                                other = 16)) +
  labs(x = "Generation time (yrs)", y = "Mutation rate per site per generation") +
  theme_classic() +
  theme(legend.position = "none")
plot1

#maturation time
plot2 <- ggplot(data, aes(x = maturation_time, y = mutation_rate)) +
  geom_point(aes(color = group, shape = group, fill = group), size = 3) +
  geom_smooth(
    data = subset(data, !grepl("^highlight", group)),
    method = "lm", se = TRUE, color = "black", fullrange = TRUE
  ) +
  scale_color_manual(values = c(highlight1 = "red",
                                highlight2 = "red",
                                fish = "blue",
                                other = "black")) +
  scale_fill_manual(values = c(highlight1 = "red",
                               highlight2 = "red",
                               fish = "blue",
                               other = "black")) +
  scale_shape_manual(values = c(highlight1 = 24,
                                highlight2 = 25,
                                fish = 17,
                                other = 16)) +
  labs(x = "Maturation time (yrs)", y = "Mutation rate per site per generation") +
  theme_classic() +
  theme(legend.position = "none")
plot2

#lifespan
plot3 <- ggplot(data, aes(x = lifespan, y = mutation_rate)) +
  geom_point(aes(color = group, shape = group, fill = group), size = 3) +
  geom_smooth(
    data = subset(data, !grepl("^highlight", group)),
    method = "lm", se = TRUE, color = "black", fullrange = TRUE
  ) +
  scale_color_manual(values = c(highlight1 = "red",
                                highlight2 = "red",
                                fish = "blue",
                                other = "black")) +
  scale_fill_manual(values = c(highlight1 = "red",
                               highlight2 = "red",
                               fish = "blue",
                               other = "black")) +
  scale_shape_manual(values = c(highlight1 = 24,
                                highlight2 = 25, 
                                fish = 17,
                                other = 16)) +
  labs(x = "Lifespan in the wild (yrs)", y = "Mutation rate per site per generation") +
  theme_classic() +
  theme(legend.position = "none")
plot3
####

#effective population size
plot4 <- ggplot(data, aes(x = Ne, y = mutation_rate)) +
  geom_point(aes(color = group, shape = group, fill = group), size = 3) +
  #log-scaled x-axis
  scale_x_log10(
    breaks = scales::breaks_log()(data$Ne),
    labels = function(x) log10(x)
  ) +
  scale_y_continuous(trans = "log10")+
  geom_smooth(
    data = subset(data, !grepl("^highlight", group)),
    method = "lm", se = TRUE, color = "black", fullrange = TRUE
  ) +
  scale_color_manual(values = c(highlight1 = "red",
                                highlight2 = "red",
                                fish = "blue",
                                other = "black")) +
  scale_fill_manual(values = c(highlight1 = "red",
                               highlight2 = "red",
                               fish = "blue",
                               other = "black")) +
  scale_shape_manual(values = c(highlight1 = 24,   # filled triangle, point up
                                highlight2 = 25,   # filled triangle, point down
                                fish = 17,
                                other = 16)) +
  labs(
    x = expression("N" [e] ~ "(log" [10] * ")"),
    y =  expression("Mutation rate per site per generation" ~ "(log" [10] * ")")#~ "(log" [10] * ")")
  ) +
  theme_classic()+
  theme(legend.position = "none")
plot4

#predict DHP value based on bergeron
#log
model_predict_log <- lm(log10(mutation_rate) ~ log10(Ne), data = subset(data, species_name != highlight_individual))
summary(model_predict_log)
predict_log <- predict(model_predict_log, newdata = data.frame(Ne = 165))
10^predict_log

# get fitted value and 95% CI
predict_log <- predict(model_predict_log, newdata = data.frame(Ne = 391), interval = "confidence", level = 0.95)
predict_log

#NE391 - based on singleton mutation rate
Ne391fit <- -7.947059
Ne391lwr <- -8.116357
Ne391upr <- -7.77776
10^Ne391fit #1.129642e-08
10^Ne391lwr #7.649675e-09
10^Ne391upr #1.668169e-08

#NE507 - based on gene conversion corrected mutation rate
predict_log <- predict(model_predict_log, newdata = data.frame(Ne = 507), interval = "confidence", level = 0.95)
predict_log
Ne507fit <- -7.957958
Ne507lwr <- -8.119186
Ne507upr <- -7.796731
10^Ne507fit #1.101646e-08
10^Ne507lwr #7.600007e-09
10^Ne507upr #1.596868e-08

#efffective popualtion size, just fish
plot5 <- ggplot(subset(data, taxonomic_group == "Fish"), aes(x = Ne, y = mutation_rate)) +
  geom_point(aes(color = group, shape = group, fill = group), size = 3) +
  # Log-scaled x-axis
  scale_x_log10(
    breaks = scales::breaks_log()(data$Ne),
    labels = function(x) log10(x)
  ) +
  scale_y_continuous(trans = "log10")+
  geom_smooth(
    data = subset(data, species_name != highlight_individual & taxonomic_group == "Fish"),
    method = "lm",
    se = TRUE,
    color = "blue",
    fullrange = TRUE
  ) +
  scale_color_manual(values = c(highlight1 = "red",
                                highlight2 = "red",
                                fish = "blue",
                                other = "black")) +
  scale_fill_manual(values = c(highlight1 = "red",
                               highlight2 = "red",
                               fish = "blue",
                               other = "black")) +
  scale_shape_manual(values = c(highlight1 = 24,
                                highlight2 = 25,
                                fish = 17,
                                other = 16)) +
  labs(
    x = expression("N" [e] ~ "(log" [10] * ")"),
    y =  expression("Mutation rate per site per generation" ~ "(log" [10] * ")")
  ) +
  theme_classic()+
  theme(legend.position = "none")
plot5


combined_plot <- (plot1 | plot2 | plot3) / (plot4 | plot5)+
  plot_annotation(tag_levels = 'A')

print(combined_plot)


###########
#fishsubset
fish_subset<- data %>% filter(taxonomic_group == "Fish")
fish_subset_no_DHP <- fish_subset[fish_subset$species_name != "Cyprinodon_diabolis", ]

#modeling
fish_noDHP_model <- lm(mutation_rate ~ log10(Ne), data = fish_subset_no_DHP)
summary(fish_noDHP_model)

#test new data 
fish_test_Nes <- data.frame(Ne = c(1e1, 1e2, 1e3, 1e4, 1e5))
fish_test_Nes$predicted_mutation_rate <- predict(fish_noDHP_model, fish_test_Nes)
print(fish_test_Nes)

#check out plot
fish_noDHP_prediction <- ggplot(fish_test_Nes, aes(x = Ne, y = predicted_mutation_rate)) +
  geom_point() +
  scale_x_log10() +
  labs(
    x = expression("N" [e] ~ "(log" [10] * ")"),
    y =  expression("Mutation rate per site per generation" ~ "(log" [10] * ")")
  ) +
  theme_classic()
fish_noDHP_prediction

#PGLS
con <- xzfile("actinopt_12k_raxml.tre.xz", "rt")
tree_text <- readLines(con)
close(con)

fish_tree <- read.tree(text = tree_text)
fish_tree

plot(fish_tree, no.margin = TRUE, font = 3, cex = .75)

#data
fish_subset_no_DHP

#check if data are in tree
fish_subset_no_DHP2 <- as.data.frame(fish_subset_no_DHP)
rownames(fish_subset_no_DHP2) <- fish_subset_no_DHP2$species_name
obj<-name.check(fish_tree, fish_subset_no_DHP2)
obj

#double check tongue sole not in tree 
"Cynoglossus_semilaevis" %in% fish_tree$tip.label

#mulitple other soles in the tree
grep("^Cynoglossus_", fish_tree$tip.label, value = TRUE)

#look at Cynoglossus clade 
genus <- "Cynoglossus"
tips <- grep(paste0("^", genus, "_"), fish_tree$tip.label, value = TRUE)
tips
Cynoglossus_subtree <- keep.tip(fish_tree, tips)
plot(Cynoglossus_subtree, cex=0.6)
#closest to semilaevis is joyneri 

#rename joyneri to semilaevis in the tree 
fish_tree2 <- fish_tree
fish_tree2$tip.label[fish_tree2$tip.label == "Cynoglossus_joyneri"] <- "Cynoglossus_semilaevis"

#check if data are in tree
obj2<-name.check(fish_tree2, fish_subset_no_DHP2)
obj2

#prune extra species 
fish.tree.short <-drop.tip(fish_tree2, obj2$tree_not_data)
name.check(fish.tree.short,fish_subset_no_DHP2)

#PGLS under brownian motion 
bm<-corBrownian(1, fish.tree.short)
bm

#look at mut rate vs. Ne 
#no correction from lambda
model.1<-gls(mutation_rate~Ne, data=fish_subset_no_DHP2, correlation=bm)

#visualize model 
plot(mutation_rate~Ne, data=fish_subset_no_DHP2)
abline(a = coef(model.1)[1], b = coef(model.1)[2])
summary(model.1)
#pvalue 0.6512

#incorporating lambda
model.2<-gls(mutation_rate~Ne, data=fish_subset_no_DHP2, correlation=corPagel(1,fish.tree.short))
plot(mutation_rate~Ne, data=fish_subset_no_DHP2)
abline(a = coef(model.2)[1], b = coef(model.2)[2])
summary(model.2)
#lambda: -0.6508713 
#so basically 0, does not require phylogenetic correction 
#PGLS changes the regression line, the slope, the intercept, and the estimated residual variance
#Brownian lambda = 1, Pagels allows for 0-1. if zero, then, Pagels = OLS

#comparing DHP mutation rate to data from de Manuel et al. 2026. 
dat <- read.csv("deManuel_data_supp_table1_with_DHP.csv")
dat$species <- gsub(" ", "_", dat$species) #add underscores
setdiff(pruned$tip.label, dat$species)


deManuel_tree <- read.tree("deManuel_Fig1_species_with_DHP.nwk") #has additional nodes from tree of life that need to be pruned
plot(deManuel_tree, no.margin = TRUE, font = 3, cex = .75)
mine <- readLines("deManuel_Fig1_species_with_DHP_underscore.txt")
length(deManuel_tree$tip.label) #78 tips
setdiff(deManuel_tree$tip.label, mine) #see species in the tree I don't want
#keep the first tip for each species if there are multiple
genus_species <- sapply(strsplit(deManuel_tree$tip.label, "_"), function(x) paste(x[1:2], collapse = "_"))
keep_idx <- which(genus_species %in% mine & !duplicated(genus_species))
pruned <- keep.tip(deManuel_tree, deManuel_tree$tip.label[keep_idx])
pruned$tip.label <- sapply(strsplit(pruned$tip.label, "_"),function(x) paste(x[1:2], collapse = "_"))
plot(pruned, no.margin = TRUE, font = 3, cex = .75)


taxon_cols <- c(mammals = "#009E73", fish = "blue", arthropods = "#D55E00",
                birds = "#E69F00", reptiles = "#CC79A7", worms = "#56B4E9")

p_tree <- ggtree(pruned) %<+% dat +
  geom_tiplab(aes(label = gsub("_", " ", label), color = taxon),
              size = 3, fontface = "italic", offset = 1) +
  scale_color_manual(values = taxon_cols, name = "Taxon") +
  xlim_tree(max(node.depth.edgelength(pruned)) * 1.6) +
  theme_tree() +
  theme(legend.position = "none")
p_tree


#####
#include both singleton and gene conversion corrected estimates
mut_long <- pivot_longer(dat,
                         cols = c(mutation_rate, mutation_rate_alt1, mutation_rate_alt2),
                         names_to = "method", values_to = "rate",
                         values_drop_na = TRUE)

#alt1 = singleton rate, alt2 = MAF regression rate
mut_long$method <- factor(mut_long$method,
                          levels = c("mutation_rate", "mutation_rate_alt1", "mutation_rate_alt2"))

p_mut <- ggplot(mut_long, aes(x = rate, y = species)) +
  geom_point(aes(color = taxon, shape = method), size = 4) +
  scale_color_manual(values = taxon_cols, name = "Taxon") +
  scale_shape_manual(values = c(mutation_rate      = 16,
                                mutation_rate_alt1 = 0,
                                mutation_rate_alt2 = 18)) +
  guides(color = "none", shape = "none") +
  scale_x_log10(limits = c(1e-10, 1e-7),
                breaks = 10^(-10:-7),
                labels = scales::label_log()) +
  labs(x = "Mutation rate \n per bp per generation", y = NULL) +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "none")
p_mut

#generation time
p_gen <- ggplot(dat, aes(x = generation_time, y = species, color = taxon)) +
  geom_point(size = 4) +
  scale_color_manual(values = taxon_cols, name = "Taxon") +
  scale_x_log10(limits = c(0.001, 100),
                breaks = c(0.01, 0.1, 1, 10),
                labels = c("0.01", "0.1", "1", "10")) +
  labs(x = "Generation time \n(years)", y = NULL) +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "none")
p_gen

#merge together
treerow<- p_mut %>%
  insert_left(p_tree, width = 2) %>%
  insert_right(p_gen)

tree_panel <- patchwork::wrap_elements(full = aplot::as.patchwork(treerow))
tree_panel
