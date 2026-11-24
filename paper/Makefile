# Build the draft with pandoc (https://pandoc.org). Output goes to paper/build/ (git-ignored).
# `make`      -> HTML (no LaTeX needed)
# `make pdf`  -> PDF (needs a working LaTeX installation)
.PHONY: all pdf overleaf overleaf-pdf clean

all: build/draft.html

build/draft.html: draft.md references.bib
	mkdir -p build
	pandoc draft.md --citeproc --standalone -o build/draft.html

pdf: draft.md references.bib
	mkdir -p build
	pandoc draft.md --citeproc -o build/draft.pdf

# `make overleaf` -> overleaf/main.tex + references.bib in The Cryosphere (Copernicus) format.
# Upload the whole overleaf/ folder (it also holds copernicus.cls/.cfg/.bst and pdfscreen*.sty,
# from https://www.the-cryosphere.net/Copernicus_LaTeX_Package.zip) and compile with pdfLaTeX.
# Template and section mapping: copernicus/template.tex and copernicus/copernicus.lua.
overleaf: draft.md references.bib copernicus/template.tex copernicus/copernicus.lua
	mkdir -p overleaf
	pandoc draft.md --natbib --lua-filter=copernicus/copernicus.lua \
		--template=copernicus/template.tex -o overleaf/main.tex
	cp references.bib overleaf/

# `make overleaf-pdf` -> compile overleaf/main.tex locally into build/overleaf/ (needs latexmk)
overleaf-pdf: overleaf
	mkdir -p build/overleaf
	cd overleaf && latexmk -pdf -interaction=nonstopmode -outdir=../build/overleaf main.tex

clean:
	rm -rf build
