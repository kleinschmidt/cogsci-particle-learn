all: cogsci-particle-learn.pdf

%.md: %.jmd
	julia -e 'using Weave; weave("$<", doctype="pandoc", throw_errors=true, fig_ext=".pdf", cache=:all)'

%.tex: %.md cogsci_template.tex
	pandoc -f markdown -t latex -o $@ --template=latexpaper/cogsci_template.tex $<

%.pdf: %.tex
	latexmk -halt-on-error -pdf $< && latexmk -c
