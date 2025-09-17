#!/usr/bin/env bash

# WIP: migrating towards LaTeX!
pandoc --standalone                 \
    --metadata=book.yaml            \
    --toc                           \
    --citeproc                      \
    --csl=nature.csl                \
    --bibliography="references.bib" \
    book.md                         \
    src/scientific-computing.md     \
    src/operating-systems.md        \
    src/using-containers.md         \
    src/elmer-multiphysics.md       \
    src/general-tips.md             \
    -o book.pdf
    # --pdf-engine=xelatex            \
