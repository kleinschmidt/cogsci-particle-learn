.PHONY: all clearcache
all: cogsci-particle-learn.pdf
clearcache:
	rm cache/cogsci-particle-learn.jld2

%.md: %.jmd
	julia -e 'using Weave; weave("$<", doctype="pandoc", throw_errors=true, fig_ext=".pdf", cache=:all)'

%.tex: %.md cogsci_template.tex
	pandoc -f markdown -t latex -o $@ --biblatex --filter=pandoc-crossref --template=latexpaper/cogsci_template.tex $<

%.pdf: %.tex
	latexmk -halt-on-error -pdf $< && latexmk -c
