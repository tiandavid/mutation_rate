#generating plot for bergeron 8 species spectra
#Fig. 4A

library(dplyr)
library(tidyr)
library(ggplot2)

#read in data
data <- read.csv("bergeron8spectra.csv")

# normalize within each fish
data_prop <- data %>%
  rowwise() %>%
  mutate(total = sum(c_across(`CtoA`:`TtoG`), na.rm = TRUE)) %>%
  mutate(across(`CtoA`:`TtoG`, ~ ifelse(total == 0, NA_real_, .x / total))) %>%
  ungroup() %>%
  select(-total)

# pivot to long
data_long <- data_prop %>%
  pivot_longer(cols = -Fish, names_to = "MutationType", values_to = "Proportion")

# separate C>T from other spectra
data_long <- data_long %>%
  mutate(
    MainType = case_when(
      MutationType %in% c("CtoT_noCpG", "CtoT_CpG") ~ "CtoT",
      TRUE ~ MutationType
    ),
    SubType = MutationType
  )
data_long$Proportion <- as.numeric(data_long$Proportion)

# calc mean and SE
summary_stats <- data_long %>%
  group_by(MainType, SubType) %>%
  summarise(
    Mean = mean(Proportion),
    SE = sd(Proportion)/sqrt(n()),
    .groups = 'drop'
  )

# make sure MainType is consistent
summary_stats <- summary_stats %>%
  mutate(MainType = case_when(
    SubType %in% c("CtoT_CpG", "CtoT_noCpG") ~ "CtoT",
    TRUE ~ SubType
  ))

# set factors for right order
summary_stats$MainType <- factor(summary_stats$MainType,
                                 levels = c("CtoA", "CtoG", "CtoT", "TtoA", "TtoC", "TtoG"),
                                 labels = c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G"))

summary_stats$SubType <- factor(summary_stats$SubType,
                                levels = c("CtoT_noCpG", "CtoT_CpG", "CtoA", "CtoG", "TtoA", "TtoC", "TtoG"))

# calc cumulative height for error bars
summary_stats <- summary_stats %>%
  group_by(MainType) %>%
  arrange(MainType, SubType) %>%
  mutate(
    cumulative_height = cumsum(Mean),
    bar_top = cumulative_height,
    ymin = bar_top - SE,
    ymax = bar_top + SE
  )

# plot
bergeron8plot <- ggplot(summary_stats, aes(x = MainType, y = Mean, fill = SubType)) +
  geom_bar(stat = "identity", position = position_stack(reverse = TRUE), width = 0.9) +
  geom_errorbar(aes(ymin = ymin, ymax = ymax),
                width = 0.2) +
  labs(x = "Mutation Type", y = "Relative contribution", fill = "Subcategory") +
  theme_linedraw() +
  scale_fill_manual(values = c(
    "CtoA" = "deepskyblue", "CtoG" = "black",  
    "CtoT_CpG" = "salmon", "CtoT_noCpG" = "red",
    "TtoA" = "gray", "TtoC" = "olivedrab3",
    "TtoG" = "pink")) +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position="none")
bergeron8plot
