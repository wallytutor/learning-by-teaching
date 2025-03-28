#!/bin/bash

gs                           \
-sDEVICE=pdfwrite            \
-dCompatibilityLevel=1.4     \
-dPDFSETTINGS=/default       \
-dNOPAUSE                    \
-dQUIET                      \
-dBATCH                      \
-dDetectDuplicateImages      \
-dCompressFonts=true         \
-r100                        \
-sOutputFile="thesis-out.pdf"\
"thesis.pdf"
