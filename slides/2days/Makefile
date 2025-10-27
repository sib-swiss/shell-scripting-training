.PHONY: mrproper clean


MARKDOWNS = $(wildcard shell-scripting-day?.md) project.md
PDFS = $(addsuffix .pdf, $(basename $(MARKDOWNS)))

all: $(PDFS) 

# dark shell code highlight styles include breezeDark, espresso, zenburn
%.pdf: %.md Makefile beamer-header.tex metadata.yaml
	pandoc --standalone --to=beamer --pdf-engine=xelatex \
		--highlight-style zenburn \
		--metadata-file=metadata.yaml \
		--include-in-header beamer-header.tex \
		--resource-path images $< -o $@ 

clean:
	$(RM) *.aux *.log *.nav *.snm *.toc *.vrb

mrproper: clean
	$(RM) $(PDFS)
