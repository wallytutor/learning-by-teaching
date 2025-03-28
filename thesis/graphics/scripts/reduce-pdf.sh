#!/bin/bash

mkdir "source";
mkdir "output";

for fname in $(ls -1 *.pdf | sed -e 's/\..*$//')
do
    OUTPUT="output/${fname}.pdf";

    gs                          \
    -sDEVICE=pdfwrite            \
    -dCompatibilityLevel=1.4    \
    -dPDFSETTINGS=/default      \
    -dNOPAUSE                   \
    -dQUIET                     \
    -dBATCH                     \
    -dDetectDuplicateImages     \
    -dCompressFonts=true        \
    -r200                       \
    -sOutputFile="${OUTPUT}"    \
    "${fname}.pdf"
done

mv *.pdf source/ ;
mv output/* .    ;
rm -rf output    ;