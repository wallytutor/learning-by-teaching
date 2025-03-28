#!/bin/bash

for fname in $(ls -1 *.dot | sed -e 's/\..*$//')
do
    printf "Making ${fname}.pdf\n";
    dot -Tpdf ${fname}.dot -o ${fname}.pdf;
done
