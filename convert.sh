#!/usr/bin/env bash

AUTHOR="Walter Dal'Maz Silva"

DATE="$(date)"

REFERENCES=../Dossiers/programs/WallyToolbox.jl/data/bibtex/references.bib

COMBUSTION=(
    "combustion/combustion-fundamentals.md"
    "combustion/energy-sources.md"
)

BIBLE=(
    "software/README.md"
    "software/cli.md"
    "software/vscode.md"
    "software/windows.md"
    "software/linux.md"
    "software/git.md"
    "software/containers.md"
    "software/latex.md"
    "software/regex.md"
    "software/general.md"
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
