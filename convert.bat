@echo off

setlocal

set dtcmd="wmic os get localdatetime /value"

for /f "tokens=2 delims==" %%i in ('%dtcmd%') do set datetime=%%i

set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%

set DATE=%year%-%month%-%day%

set AUTHOR="Walter Dal'Maz Silva"

set REFERENCES=references.bib

pandoc --standalone              ^
    -M title="Computing bible"   ^
    -M author=%AUTHOR%           ^
    -M date=%DATE%               ^
    --toc                        ^
    --citeproc                   ^
    --csl=nature.csl             ^
    --bibliography=%REFERENCES%  ^
    --highlight-style=pygments   ^
    book.md                      ^
    -o book.pdf                  ^
    references.md
