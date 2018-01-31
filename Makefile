all: cogsci-particle-learn.tex

%.md: %.jmd
	julia -e 'using Weave; weave("$<", doctype="pandoc")'

%.tex: %.md
	pandoc -f markdown -t latex -o $@ --template=latexpaper/cogsci_template.tex $<

%.pdf: %.tex
	latexmk -pdf $<
