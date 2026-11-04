# Build the draft with pandoc (https://pandoc.org). Output goes to paper/build/ (git-ignored).
# `make`      -> HTML (no LaTeX needed)
# `make pdf`  -> PDF (needs a working LaTeX installation)
all: build/draft.html

build/draft.html: draft.md references.bib
	mkdir -p build
	pandoc draft.md --citeproc --standalone -o build/draft.html

pdf: draft.md references.bib
	mkdir -p build
	pandoc draft.md --citeproc -o build/draft.pdf

clean:
	rm -rf build
