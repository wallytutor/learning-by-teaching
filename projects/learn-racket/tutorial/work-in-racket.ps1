param ( [string]$fileName = "" )

racket.exe -i -f "../racketrc" -f $fileName
