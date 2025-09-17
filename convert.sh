### PARAMETERS

CleanLevel="${1:-2}"

### CONVERT

pandoc                           \
    src/scientific-computing.md  \
    src/operating-systems.md     \
    src/using-containers.md      \
    src/elmer-multiphysics.md    \
    src/general-tips.md          \
    --metadata-file=book.yaml    \
    --template=book.tex          \
    --biblatex                   \
    --pdf-engine=xelatex         \
    -o "book_.tex"

### BUILD

xelatex book_.tex
biber   book_
xelatex book_.tex
xelatex book_.tex

### CLEAN

if [ $CleanLevel -gt 0 ]; then
    rm -rf *.aux *.bbl *.bcf *.blg *.run.xml *.toc
fi


if [ $CleanLevel -gt 1 ]; then
    rm -rf *.log book_.tex
fi


### EOF