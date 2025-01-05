#!/usr/bin/env bash

AUTHOR="Walter Dal'Maz Silva"

DATE="$(date)"

REFERENCES=../Dossiers/programs/WallyToolbox.jl/data/bibtex/references.bib

COMBUSTION=(
    "combustion/combustion-fundamentals.md"
    "combustion/energy-sources.md"
)

pandoc --standalone                \
    -M title="Combustion"          \
    -M author="${AUTHOR}"          \
    -M date="${DATE}"              \
    --toc                          \
    --citeproc                     \
    --csl=template/nature.csl      \
    --bibliography="${REFERENCES}" \
    -o outputs/combustion.pdf      \
    ${COMBUSTION[@]}               \
    template/references.md
