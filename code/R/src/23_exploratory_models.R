library("GGally")

X <- DT[, .(stn_end, stn_sdrcl, stn_dprcl, stn_rpsd, stn_cgpp)]

ggscatmat(DT, columns = 58:61, color = "cluster")

X <- scale(X)

clusters <- kmeans(X, centers = 4)

DT[, cluster := as.factor(clusters$cluster)]

DT %>% 
    ggplot(aes(x = stn_end, y = stn_cgpp, color = cluster)) +
    geom_point()

DT %>% 
    ggplot(aes(x = stn_dprcl, y = fitted, color = cluster)) +
    geom_point()


DT[id %in% c("rj2016", "rs2016", "mg2016"), .(id, default, cluster)]
DT[cluster == 7, .(id, default, cluster)]

DT[cluster == 7, default := 1]


hc.complete <- hclust(dist(X), method="complete")

plot(hc.complete,main="Complete Linkage", xlab="", sub="",
     cex =.9)

cutree(hc.complete, h = 3.5) %>% unique %>% length()
