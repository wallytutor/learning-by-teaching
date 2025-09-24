#lang racket

(define output-dir "output")

(define (concat-with-space . args)
  (string-join args " "))

(define (ensure-dir path)
  (unless (directory-exists? path)
    (displayln (string-append "Creating directory: " path))
    (make-directory* path)))

(define (compile-command . args)
  (ensure-dir output-dir)
  (apply concat-with-space "raco scribble --dest" output-dir args))

(define (print-command-message command)
  (displayln (string-append "Running command: " command)))

(define (print-format-error output-format)
  (displayln (string-append "Unknown output: " output-format)))

(define (generate-document output-format file-path)
  (let ([command (compile-command output-format file-path)])
    (print-command-message command)
    (system command)))

(define (validate-format output-format)
  (member output-format (list "--html" "--htmls" "--pdf")))

(define (compile-scribble output-format file-path)
  (if (validate-format output-format)
    (generate-document output-format file-path)
    (print-format-error output-format))
  (void))

; raco pkg install scribble-math
; raco pkg install scribble-slideshow
(compile-scribble "--pdf"  "report.rkt")
; (compile-scribble "--htmls" "slides.rkt")