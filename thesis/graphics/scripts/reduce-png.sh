#!/bin/bash

fmt="png"
mkdir "source";
mkdir "output";

for fname in $(ls -1 *.${fmt} | sed -e 's/\..*$//')
do
    OUTPUT="output/${fname}.${fmt}";

    convert                       \
        -verbose                  \
        -density 100              \
        -trim                     \
        "${fname}.png"            \
        -quality 50               \
        -flatten                  \
        "${OUTPUT}"    
done

mv *.${fmt} source/ ;
mv output/* .    ;
rm -rf output    ;