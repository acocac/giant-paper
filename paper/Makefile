# Build the draft with pandoc (https://pandoc.org). Output goes to paper/build/ (git-ignored).
# `make`      -> HTML (no LaTeX needed)
# `make pdf`  -> PDF (needs a working LaTeX installation)
.PHONY: all pdf overleaf clean

all: build/draft.html

build/draft.html: draft.md references.bib
	mkdir -p build
	pandoc draft.md --citeproc --standalone -o build/draft.html

pdf: draft.md references.bib
	mkdir -p build
	pandoc draft.md --citeproc -o build/draft.pdf

# `make overleaf` -> overleaf/main.tex + references.bib; upload both to Overleaf (natbib, compile with pdfLaTeX)
overleaf: draft.md references.bib
	mkdir -p overleaf
	pandoc draft.md --natbib -V biblio-style=plainnat --standalone -o overleaf/main.tex
	cp references.bib overleaf/

clean:
	rm -rf build
