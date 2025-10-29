.PHONY: mrproper clean debug


MARKDOWNS = $(wildcard shell-scripting-day?.md)
PDFS = $(addsuffix .pdf, $(basename $(MARKDOWNS)))

all: $(PDFS) 

# dark shell code highlight styles include breezeDark, espresso, zenburn
shell-scripting-day%.pdf: shell-scripting-day%.md Makefile beamer-header.tex
	pandoc --standalone --to=beamer --pdf-engine=xelatex \
		--highlight-style zenburn \
		--metadata-file=metadata.yaml \
		--include-in-header beamer-header.tex \
		--resource-path images $< -o $@ 

clean:
	$(RM) *.aux *.log *.nav *.snm *.toc *.vrb 

mrproper: clean
	$(RM) shell-scripting-*.pdf
