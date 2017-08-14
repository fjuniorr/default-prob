library(ggjoy); library(tidyverse); library(data.table); library(broom)

DT <- fread("data/analytic_data.csv")
dict <- yaml::yaml.load_file("data/fiscal-indicators.yaml")
# ==========================================================
# exploratory stats
# ==========================================================
dict[["capag_pc"]]$def_pt
DT[, stn_end] %>% summary()
DT[, .(avg = mean(stn_end), sd = sd(stn_end), .N), by = state_calamity]
DT[, .(avg = mean(stn_end), sd = sd(stn_end), .N), by = calamity]

# ==========================================================
# exploratory viz
# ==========================================================

# x|year, calamity
DT %>% 
    ggplot(aes(x = factor(year), y = capag_idc, color = state_calamity)) +
    geom_boxplot(position=position_dodge(1))

# x|year, calamity
DT %>% 
    ggplot(aes(x = capag_idc, y = factor(year, 2016:2008), fill = state_calamity, colour = state_calamity)) + 
    geom_joy(alpha=.3) 

# x|calamity, state
DT %>% 
    ggplot(aes(x = capag_idc, y = state, fill = state_calamity, colour = state_calamity)) + 
    geom_joy(alpha=.3) 

# x|year, calamity, state
DT %>% 
    ggplot(aes(x = year, y = capag_idc, color = default)) +
    geom_point() +
    facet_wrap( ~ state)

# ==========================================================
DT[, .(stn_end ,stn_sdrcl ,stn_rpsd ,stn_dprcl ,stn_cgpp ,stn_pidt ,stn_pcrdp ,stn_rtdc)] %>% 
    cor() %>% 
    corrplot::corrplot(type="lower", order ="AOE")


# ==========================================================
# variables range
# ==========================================================
var <- "stn_rpsd"
x <- DT[[var]]

hist(x)
mean(x)
sd(x)
sd(x)*2
upper <- mean(x) + 2*sd(x)
upper
lower <- mean(x) - 2*sd(x)
lower
summary(x)

DT[!((x > lower ) & (x < upper)), c("id", "state", "yh1", var) , with = FALSE][order(state)]

# ==========================================================
# exploratory models
# ==========================================================

fit <- DT %>% 
        split(.$state) %>% 
        map(~lm(stn_end ~ year, data = .x)) 

fit %>% 
    map(glance) %>% 
    map("adj.r.squared") %>% 
    unlist() %>% 
    sort(decreasing = TRUE) %>% 
    barplot(las = 2)

fit %>% 
    map(tidy) %>% 
    map(~ .x[2, c("estimate")]) %>% 
    stack() %>% 
    mutate(ind = reorder(ind, values), pos = values >= 0) %>% 
    ggplot(aes(x = ind, y = values, fill = pos)) + geom_bar(stat = "identity") + geom_text(aes(label=round(values, 2)), vjust=1.5, colour="white", size = 2.5)

fit %>% 
    map(tidy) %>% 
    map(~ .x[2, c("estimate")]) %>% 
    stack() %>%        
    ggplot(aes(x=values, y=reorder(ind, values))) +
    geom_segment(aes(yend=ind), xend=0, colour="grey50") +
    geom_point() +
    theme_bw()

