#!/usr/bin/env bash

# WIP: migrating towards LaTeX!
pandoc --standalone                 \
    --metadata=book.yaml            \
    --toc                           \
    --citeproc                      \
    --csl=nature.csl                \
    --bibliography="references.bib" \
    -o book.pdf book.md
