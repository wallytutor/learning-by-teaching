@echo off

setlocal

set dtcmd="wmic os get localdatetime /value"

for /f "tokens=2 delims==" %%i in ('%dtcmd%') do set datetime=%%i

set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%

set DATE=%year%-%month%-%day%

set AUTHOR="Walter Dal'Maz Silva"

set REFERENCES=references/references.bib

pandoc --standalone                ^
    -M title="Computing bible"     ^
    -M author=%AUTHOR%             ^
    -M date=%DATE%                 ^
    --toc                          ^
    --citeproc                     ^
    --csl=template/nature.csl      ^
    --bibliography=%REFERENCES%    ^
    --highlight-style=pygments     ^
    software/README.md             ^
    software/cli.md                ^
    software/vscode.md             ^
    software/windows.md            ^
    software/linux.md              ^
    software/git.md                ^
    software/containers.md         ^
    software/latex.md              ^
    software/regex.md              ^
    software/general.md            ^
    -o outputs/bible.pdf           ^
    template/references.md
