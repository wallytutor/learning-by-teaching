#lang racket

(require racket/format)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRINTING HELPERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-field-name name n)
  (~a name #:min-width n #:align 'left))

(define-syntax-rule (show-hash width h key)
  (printf "~a = ~a\n" (make-field-name (symbol->string key) width) (hash-ref h key)))

(define (print-spacer #:n [n 30]) (printf "~a\n" (make-string n #\-)))

(define (print-label name) (printf "\n~a\n" name) (print-spacer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA STRUCTURE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-ip-hash
  data-version
  num-dims
  num-points
  num-vars
  vars-names
  dims
  vars)
  (hash 'data-version data-version
        'num-dims     num-dims
        'num-points   num-points
        'num-vars     num-vars
        'vars-names   vars-names
        'dims         dims
        'vars         vars))

(define (printed-size arr) (string-append "#" (number->string (length arr))))

(define (print-ip-head h)
  (when (hash? h)
    (print-label "Interpolation file info")
    (show-hash 15 h 'data-version)
    (show-hash 15 h 'num-dims)
    (show-hash 15 h 'num-points)
    (show-hash 15 h 'num-vars)))

(define (print-ip-fields h)
  (when (hash? h)
    (print-label "Variable names")
    (for ([(name idx) (in-indexed (hash-ref h 'vars-names))])
      (printf "field ~a = ~a\n" (make-field-name (number->string idx) 9) name))
    ))

(define (print-ip-dims h)
  (when (hash? h)
    (print-label "Coordinates")
    (for ([(key val) (in-hash h)])
      (printf "~a = ~a\n" (make-field-name key 15) (printed-size val)))
    ))

(define (print-ip-vars h)
  (when (hash? h)
    (define names (hash-ref h 'vars-names))
    (define ip-vars (hash-ref h 'vars))
    (print-label "Variables")
    (for ([key names])
      (define name (make-field-name key 15))
      (define value (printed-size (hash-ref ip-vars key)))
      (printf "~a = ~a\n" name value))
    ))

(define (print-ip h)
  (when (hash? h)
    (print-ip-head h)
    (print-ip-fields h)
    (print-ip-vars h)
    (print-ip-dims (hash-ref h 'dims))
    (print-spacer)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PARSING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (read-trim fp)
  (regexp-replace* #rx"[\r\n]" (read-line fp) ""))

(define (read-number fp)
  (string->number (read-trim fp)))

(define (read-list fp n)
  (for/list ([_ (in-range n)]) (read-trim fp)))

(define (parse-field-data fp n)
  (read (open-input-string (string-join (read-list fp n) " "))))

(define (read-field-as-hash fp names num-points)
    (define field-hash (make-hash))
    (for ([curr-name (in-list names)])
      (define curr-vals (parse-field-data fp (+ 1 num-points)))
      (hash-set! field-hash curr-name curr-vals))
    field-hash)

(define (read-interpolation-file file-path)
  (call-with-input-file file-path
    (lambda (fp)
      (define data-version (read-trim   fp))
      (define num-dims     (read-number fp))
      (define num-points   (read-number fp))
      (define num-vars     (read-number fp))

      (define vars-names
        (for/list ([_ (in-range num-vars)])
          (read-trim fp)))

      (define dims-names
        (for/list ([i (in-range num-dims)])
          (string-append "coordinate-" (number->string i))))

      (make-ip-hash
        data-version
        num-dims
        num-points
        num-vars
        vars-names
        (read-field-as-hash fp dims-names num-points)
        (read-field-as-hash fp vars-names num-points)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; APPLICATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (main)
  (define time-start (current-inexact-milliseconds))
  (define h (read-interpolation-file "sample-parse-fluent.ip"))
  (print-ip h)
  (define time-end (current-inexact-milliseconds))
  (printf "Elapsed time: ~a s\n" (/ (- time-end time-start) 1000))
)

(main)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EOF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;