#!/bin/bash

FIGURE="figure"

for infile in $(find . -maxdepth 1 -name "t*" -type d)
do
    echo "Working on ${infile}";
    
    convert                       \
        -verbose                  \
        -density 150              \
        -trim                     \
        "${infile}/${FIGURE}.pdf" \
        -quality 50               \
        -flatten                  \
        "${infile}/${FIGURE}.png"
done
