TEXDIR := results/
TEXFILE := dissertation
SECTIONS := $(wildcard results/tex/*.tex)
TABLES := $(wildcard results/tables/*.tex)
FIGURES := $(wildcard results/figs/*)
TEX_NOTES := $(patsubst notes/tex/%.tex, notes/tex/%.pdf ,$(wildcard notes/tex/*.tex))
RMD_NOTES := $(patsubst notes/rmd/%.Rmd, notes/rmd/%.html ,$(wildcard notes/rmd/*.Rmd))

.PHONY: build clean

build: results/$(TEXFILE).pdf $(TEX_NOTES) $(RMD_NOTES)

results/$(TEXFILE).pdf: $(TEXDIR)/$(TEXFILE).tex $(SECTIONS) $(TABLES) $(FIGURES) references.bib
	@echo "Atualizando $*..."
	cd $(TEXDIR); latexmk -pdf $(TEXFILE).tex
	@make clean

notes/tex/%.pdf: notes/tex/%.tex
	@echo "Atualizando $*..."
	@cd notes/tex; latexmk -pdf ./$*.tex
	@rm -f notes/tex/*.log
	@rm -f notes/tex/*.aux
	@rm -f notes/tex/*.bbl
	@rm -f notes/tex/*.blg
	@rm -f notes/tex/*.fls
	@rm -f notes/tex/*.out
	@rm notes/tex/*.fdb_latexmk


notes/rmd/%.html: notes/rmd/%.Rmd
	@echo "Atualizando $*..."
	@cd notes/rmd; Rscript -e "rmarkdown::render('$*.Rmd')"	


print:
	@echo $(TEX_NOTES)
	@echo $(RMD_NOTES)

clean:
	@rm -f $(TEXDIR)/*.log
	@rm -f $(TEXDIR)/*.aux
	@rm -f $(TEXDIR)/*.bbl
	@rm -f $(TEXDIR)/*.blg
	@rm -f $(TEXDIR)/*.fls
	@rm -f $(TEXDIR)/*.out
	@rm $(TEXDIR)/$(TEXFILE).fdb_latexmk
