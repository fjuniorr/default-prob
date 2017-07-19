library(ggjoy); library(tidyverse); library(data.table); library(broom)

DT <- fread("data/analytic_data.csv")

# ==========================================================
# SUPPORT
# ==========================================================

# https://simplystatistics.org/2017/07/13/the-joy-of-no-more-violin-plots/

DT[, gdp_per_capita := gdp / pop]

DT[, primary_oper_balance := (rec_primaria_cor - desp_primaria_cor_dv) / rec_primaria_cor]

DT[, gdp_per_capita] %>% summary()

DT[, primary_oper_balance] %>% summary()



DT %>% 
    split(.$state) %>% 
    map(~ summary(.x$gdp_per_capita)) %>%
    rbind.data.frame() %>% 
    apply(MARGIN = 1, order)


# ==========================================================

states_default <- DT[default == 1, state]

DT[state %in% states_default, state_default := 1]

DT[is.na(state_default), state_default := 0]

DT[, mean(primary_oper_balance), by = state_default]

DT[, mean(primary_oper_balance), by = default]

ggplot(DT, aes(x = primary_oper_balance)) + 
    geom_histogram() +
    facet_grid(state_default ~ .)

ggplot(DT, aes(x = primary_oper_balance)) + 
    geom_density() +
    facet_grid(state_default ~ .)

ggplot(DT, aes(x=primary_oper_balance, y=..density..)) +
    geom_histogram(fill="cornsilk", colour="grey60", size=.2) +
    geom_density() +
    facet_grid(state_default ~ .)



DT %>% 
    ggplot(aes(x = year, y = primary_oper_balance)) + 
    geom_point() + 
    facet_wrap( ~ state) +
    geom_smooth(method = "lm")

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


DT %>% 
    ggplot(aes(x = gdp / pop)) + geom_density() + facet_wrap(~factor(year))


DT %>% 
    ggplot(aes(x = eval(primary_oper_balance))) + geom_density() + facet_wrap(~factor(year))

DT %>% 
    ggplot(aes(x = eval(primary_oper_balance), y = factor(year))) + geom_joy()

DT %>% 
    ggplot(aes(x = factor(year), y = eval(primary_oper_balance))) + geom_boxplot()



DT %>% 
    ggplot(aes(x = stn_end)) + geom_line(stat = "density")

DT %>% 
    ggplot(aes(x = stn_end, y = factor(year))) + geom_joy()

DT %>% 
    ggplot(aes(x = stn_end)) + geom_line(stat = "density") + facet_wrap( ~ as.factor(year))

DT %>% 
    ggplot(aes(x = stn_end)) + geom_histogram() + facet_wrap( ~ state)