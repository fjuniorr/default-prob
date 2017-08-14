library(pdftools)

txt <- pdf_text("results/dissertation.pdf")

for(pg in txt) {
    cat(pg, file = "results/dissertation.txt", append = TRUE)
}
