library(ggplot2)
library(tidyverse)
library(scales)
library(patchwork)

#read in mutation rate data across MAF bins to calculate gene conversion corrected rate
mut_rate_per_MAFbin_per_group <- read.csv("gene_conversion_mut_rates_across_MAF_bins.csv")

#quick visualization
ggplot(mut_rate_per_MAFbin_per_group, aes(x = MAF_max_bin, y = mut_rate, color = group)) +
  geom_point() +
  theme_minimal() +
  labs(
    x = "Minor allele frequency",
    y = "Mutation rate",
    color = "Group"
  ) +
  geom_smooth(method = "lm", se = TRUE, fullrange=TRUE) +
  scale_x_continuous(limits = c(0, 0.5)) +
  scale_y_continuous(breaks = pretty_breaks(n = 10))


#adult model to get info on slope and y-intercept
mut_rate_per_MAFbin_per_group_adults <- mut_rate_per_MAFbin_per_group %>%
  filter(group == "adult")

mut_rate_per_MAFbin_per_group_adults_model <- lm(mut_rate ~ MAF_max_bin, data = mut_rate_per_MAFbin_per_group_adults)
summary(mut_rate_per_MAFbin_per_group_adults_model)
mut_rate_per_MAFbin_per_group_adults_model_coef <- coef(mut_rate_per_MAFbin_per_group_adults_model)

#R2 = 0.964
adult_adjusted_R2 <- 0.964

adult_y_intercept <- mut_rate_per_MAFbin_per_group_adults_model_coef[1] #5.072059e-09
adult_slope <- mut_rate_per_MAFbin_per_group_adults_model_coef[2] #1.459118e-08

#get 95%. CI at intercept
adult_newdata <- data.frame(MAF_max_bin = 0)
predict(mut_rate_per_MAFbin_per_group_adults_model, newdata = adult_newdata, interval = "confidence", level = 0.95)
#fit: 5.072059e-09
#lwr: 4.585566e-09
#upr: 5.558551e-09


#lethal model to get info on slope and y-intercept
mut_rate_per_MAFbin_per_group_lethals <- mut_rate_per_MAFbin_per_group %>%
  filter(group == "lethal")


mut_rate_per_MAFbin_per_group_lethals_model <- lm(mut_rate ~ MAF_max_bin, data = mut_rate_per_MAFbin_per_group_lethals)
summary(mut_rate_per_MAFbin_per_group_lethals_model)
mut_rate_per_MAFbin_per_group_lethals_model_coef <- coef(mut_rate_per_MAFbin_per_group_lethals_model)

#R2 = 0.8676
lethals_adjusted_R2 <- 0.8676

lethals_y_intercept <- mut_rate_per_MAFbin_per_group_lethals_model_coef[1] #1.277647e-08
lethals_slope <- mut_rate_per_MAFbin_per_group_lethals_model_coef[2] #2.060784e-08

#get 95%. CI at intercept
lethal_newdata <- data.frame(MAF_max_bin = 0)
predict(mut_rate_per_MAFbin_per_group_lethals_model, newdata = lethal_newdata, interval = "confidence", level = 0.95)
#fit: 1.277647e-08
#lwr: 1.139302e-08
#upr: 1.415993e-08


#set singleton rates to include in plot
adult_singleton_rate <- 6.58E-09 #all adults
lethal_singleton_rate <- 1.57E-08 #all lethals

#create plot
MAF_regression_plot <- ggplot(subset(mut_rate_per_MAFbin_per_group), aes(x = MAF_max_bin, y = mut_rate, color = group)) +
    scale_color_manual(values = c(
      "lethal" = "firebrick",
      "adult" = "steelblue"
    ))+
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, fullrange=TRUE) +
    theme_bw(base_size = 18) +
    theme(legend.position = "none")+
    labs(
      x = "Minor allele frequency",
      y = "Mutation rate per bp per generation",
      color = "group"
    ) +
    scale_x_continuous(limits = c(0, 0.5)) +
    scale_y_continuous(
      breaks = pretty_breaks(n = 10)  # more frequent y-axis ticks
    )+
    annotate("text", size=5, x = 0.05, y = 1.8e-8, label = "Embryonic lethal \n singleton mutation rate") + 
    annotate("segment", linewidth=1, x = 0.05, y = 1.7e-8, xend = 0, yend = lethal_singleton_rate,
             arrow = arrow(angle = 15, length = unit(0.25, "centimeters"), type = "closed")) + 
    annotate("text", size=5, x = 0.05, y = 9.0e-9, label = "Adult singleton \n mutation rate") +
    annotate("segment", linewidth=1, x = 0.05, y = 8.0e-9, xend = 0, yend = adult_singleton_rate,
             arrow = arrow(angle = 15, length = unit(0.25, "centimeters"), type = "closed")) +
    annotate("text", size=5, x = 0.25, y = lethals_y_intercept, label = "Embryonic lethal mutation rate\n corrected for gene conversion") +
    annotate("segment", linewidth=1, x = 0.15, y = lethals_y_intercept, xend = 0, yend = lethals_y_intercept,
             arrow = arrow(angle = 15, length = unit(0.25, "centimeters"), type = "closed")) +
    annotate("text", size=5, x = 0.25, y = adult_y_intercept, label = "Adult mutation rate corrected \n for gene conversion") +
    annotate("segment", linewidth=1, x = 0.15, y = adult_y_intercept, xend = 0, yend = adult_y_intercept,
             arrow = arrow(angle = 15, length = unit(0.25, "centimeters"), type = "closed"))
  
MAF_regression_plot





#####################################################################################
#read in singleton rate data
singleton_data <- read_csv("singleton_rates_final.csv")

set.seed(123)
#boottsrap means
bootstrap_pooled_singleton_rate <- function(df, groups,
                                            n_boot = 10000, seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  results <- list()
  
  for (g in groups) {
    
    df_g <- df[df$group == g, ]
    n <- nrow(df_g)
    
    boot_rates <- numeric(n_boot)
    
    for (i in seq_len(n_boot)) {
      
      boot <- df_g[sample(n, replace = TRUE), ]
      
      pooled_singletons <- sum(boot$singletons)
      pooled_callable_bp <- sum(boot$callable_bp)
      
      boot_rates[i] <- pooled_singletons / (2 * pooled_callable_bp)
    }
    
    results[[g]] <- boot_rates
  }
  
  results
}

boot_rates <- bootstrap_pooled_singleton_rate(
  df = singleton_data,
  groups = c("adult", "lethal"),
  n_boot = 10000,
  seed = 123
)

CI_adult  <- quantile(boot_rates$adult,  c(0.025, 0.975))
CI_lethal <- quantile(boot_rates$lethal, c(0.025, 0.975))

CI_adult
#        2.5%        97.5% 
#2.652514e-09 1.009022e-08 

CI_lethal
#2.5%       97.5% 
#1.03583e-08 2.17484e-08 

#calc. weighted mean function
weighted_mean <- function(rate, weight) {
  sum(rate * weight) / sum(weight)
}

#calc. for adult and lethal
obs_means <- tapply(
  seq_len(nrow(singleton_data)),
  singleton_data$group,
  function(idx) {
    weighted_mean(
      singleton_data$singleton_rate[idx],
      singleton_data$callable_bp[idx]
    )
  }
)

obs_means
#adult       lethal 
#6.583884e-09 1.571516e-08 

#assess diff in singleton rates between adult and lethal
bootstrap_pooled_diff <- function(df, group1, group2,
                                  n_boot = 10000, seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  # Subset the data by group
  df1 <- df[df$group == group1, ]
  df2 <- df[df$group == group2, ]
  
  diffs <- numeric(n_boot)
  
  for (i in seq_len(n_boot)) {
    
    # Resample individuals with replacement
    boot1 <- df1[sample(nrow(df1), replace = TRUE), ]
    boot2 <- df2[sample(nrow(df2), replace = TRUE), ]
    
    # Compute pooled per-base singleton rate for each group
    rate1 <- sum(boot1$singletons) / (2 * sum(boot1$callable_bp))
    rate2 <- sum(boot2$singletons) / (2 * sum(boot2$callable_bp))
    
    # Store the difference
    diffs[i] <- rate2 - rate1
  }
  
  diffs
}
boot_diffs <- bootstrap_pooled_diff(
  df = singleton_data,
  group1 = "adult",
  group2 = "lethal",
  n_boot = 10000
)


# 95% CI
CI <- quantile(boot_diffs, c(0.025, 0.975))
CI

#rate2-rate1
#2.5%        97.5% 
#2.848306e-09 1.614391e-08 

# p-value (2 sided)
p_value <- 2 * min(
  mean(boot_diffs <= 0),
  mean(boot_diffs >= 0)
)
p_value
#0.004


plot_df <- data.frame(
  group = c("adult", "lethal"),
  mean = c(obs_means["adult"], obs_means["lethal"]),
  lower = c(CI_adult[1], CI_lethal[1]),
  upper = c(CI_adult[2], CI_lethal[2])
)

singleton_plot <- ggplot(plot_df, aes(x=group, y=mean, color = group)) + 
  geom_point(size = 3) +
  geom_errorbar(aes(ymin=lower, ymax=upper), width=0.15, linewidth = 1) +
  theme_classic(base_size = 18) +
  labs(
    x = "Population",
    y = "Singleton mutation rate per bp per generation"
  )+
  scale_color_manual(values = c("steelblue", "firebrick"))+
  scale_x_discrete(labels = c("adult" = "Mature\nadult", "lethal" = "Embryonic\nlethal"))+
  theme(legend.position = "none")
singleton_plot

##combine MAF regression plot and singleton bootstrap plot
combined_plot <- MAF_regression_plot + singleton_plot + 
  plot_layout(widths = c(2.75, 1)) +
  plot_annotation(tag_levels = 'A')
combined_plot

ggsave("Fig2.revision.v1.size5.caption.pdf", plot = combined_plot)

#looking at comparing the low cov and high cov adults
adult_singleton_data <- singleton_data %>% filter(group %in% c("adult")) 

bootstrap_rates_coverage <- function(df, coverage_col,
                                     levels,
                                     n_boot = 10000,
                                     seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  results <- list()
  
  for (lev in levels) {
    
    df_sub <- df[df[[coverage_col]] == lev, ]
    n <- nrow(df_sub)
    
    boot_rates <- numeric(n_boot)
    
    for (i in seq_len(n_boot)) {
      boot <- df_sub[sample(n, replace = TRUE), ]
      
      pooled_singletons <- sum(boot$singletons)
      pooled_callable_bp <- sum(boot$callable_bp)
      
      boot_rates[i] <- pooled_singletons / (2 * pooled_callable_bp)
    }
    
    results[[lev]] <- boot_rates
  }
  
  return(results)
}

boot_rates_cov <- bootstrap_rates_coverage(
  df = adult_singleton_data,
  coverage_col = "coverage",
  levels = c("high", "medium"),
  n_boot = 10000,
  seed = 123
)


# 95% CI for each coverage group
quantile(boot_rates_cov$high, c(0.025, 0.975))
#2.5%        97.5% 
#4.452318e-09 1.277157e-08 

quantile(boot_rates_cov$medium, c(0.025, 0.975))
# 2.5%        97.5% 
#   0.000000e+00 7.632448e-09 

#calc. for adult and lethal
obs_means <- tapply(
  seq_len(nrow(adult_singleton_data)),
  adult_singleton_data$coverage,
  function(idx) {
    weighted_mean(
      adult_singleton_data$singleton_rate[idx],
      adult_singleton_data$callable_bp[idx]
    )
  }
)

obs_means
#high       medium 
#8.278268e-09 3.097232e-09 
