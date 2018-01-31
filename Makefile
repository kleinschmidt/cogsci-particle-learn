all: cogsci-particle-learn.tex

%.md: %.jmd
	julia -e 'using Weave; weave("$<", doctype="pandoc", throw_errors=true)'

%.tex: %.md cogsci_template.tex
	pandoc -f markdown -t latex -o $@ --template=latexpaper/cogsci_template.tex $<

%.pdf: %.tex
	latexmk -pdf $< && latexmk -c
