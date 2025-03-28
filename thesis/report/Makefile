# -----------------------------------------------------------------
# Programs and options
# -----------------------------------------------------------------

LATEX = pdflatex
BIBLI = bibtex
MAINF = thesis
RM    = rm -rf

# -----------------------------------------------------------------
# Compile files
# -----------------------------------------------------------------

all: thesis.pdf

thesis.pdf:
	export TEXMF="$(pwd)/class:$(TEXMF)"
	$(LATEX) $(MAINF).tex
	$(LATEX) $(MAINF).tex
	$(BIBLI) $(MAINF)
	$(LATEX) $(MAINF).tex
	$(LATEX) $(MAINF).tex

clean:
	$(RM) *.bbl *.blg *.dvi *.idx *.ilg *.ind 
	$(RM) *.toc *.lof *.lot *.log *.aux *.out

dist-clean:
	$(RM) *.pdf

# -----------------------------------------------------------------
#                              EOF
# -----------------------------------------------------------------
