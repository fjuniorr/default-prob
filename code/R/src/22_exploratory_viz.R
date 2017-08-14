library(tidyverse); library(data.table)

DT <- fread("data/analytic_data.csv")

# ==========================================================
viz_capag_idc <- DT %>% 
    ggplot(aes(x = factor(year), y = capag_idc, color = state_calamity)) +
    geom_boxplot(position=position_dodge(1)) +
    xlab("Year") + 
    ylab("Gross Debt / Net current revenue") +
    #theme_bw() +
    theme(panel.border = element_blank()) +
    theme(legend.position="none") +
    # theme(legend.position="top") +
    scale_color_discrete(name = "Financial calamity declared", labels = c("no (n = 216)", "yes (n = 27)")) +
    guides(color=guide_legend(reverse=TRUE))

ggsave("results/figs/viz_capag_idc.pdf", plot = viz_capag_idc)

# ==========================================================
viz_capag_pc <- DT %>% 
    ggplot(aes(x = factor(year), y = capag_pc, color = state_calamity)) +
    geom_boxplot(position=position_dodge(1)) +
    xlab("Year") + 
    ylab("Current expenses / Current revenue") +
    theme(legend.position="none") +
    #theme(legend.position=c(0,1), legend.justification=c(0,1)) +
    theme(panel.border = element_blank()) +
    scale_color_discrete(name = "Financial calamity declared", labels = c("no (n = 216)", "yes (n = 27)")) +
    guides(color=guide_legend(reverse=TRUE))

ggsave("results/figs/viz_capag_pc.pdf", plot = viz_capag_pc)

# ==========================================================
viz_capag_il <- DT %>% 
    ggplot(aes(x = factor(year), y = capag_il, color = state_calamity)) +
    geom_boxplot(position=position_dodge(1)) +
    xlab("Year") + 
    ylab("Current liabilities / Cash and cash equivalents") +
    # theme(legend.position="none") +
    theme(legend.position=c(0.05,0.95), legend.justification=c(0,1)) +
    theme(panel.border = element_blank()) +
    scale_color_discrete(name = "Financial calamity declared", labels = c("no (n = 216)", "yes (n = 27)")) +
    guides(color=guide_legend(reverse=TRUE))

ggsave("results/figs/viz_capag_il.pdf", plot = viz_capag_il)
