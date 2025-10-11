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

(define (make-ip-hash data-version num-dims num-points num-vars vars-names)
    (hash 'data-version data-version
          'num-dims     num-dims
          'num-points   num-points
          'num-vars     num-vars
          'vars-names   vars-names))

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

(define (print-ip h)
  (when (hash? h)
    (print-ip-head h)
    (print-ip-fields h)
    (print-spacer)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PARSING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (parse-number fp)
  (string->number (string-trim (read-line fp))))

(define (read-interpolation-file file-path)
  (call-with-input-file file-path
    (lambda (fp)
      (define data-version (read-line fp))
      (define num-dims     (parse-number fp))
      (define num-points   (parse-number fp))
      (define num-vars     (parse-number fp))

      (define vars-names
        (for/list ([_ (in-range num-vars)])
          (read-line fp)))

      (make-ip-hash
        data-version
        num-dims
        num-points
        num-vars
        vars-names
        ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; APPLICATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define h (read-interpolation-file "sandbox-sample.ip"))
(print-ip h)

;    ;; Read coordinates
;    (define coords
;     (for/list ([i (in-range num-points)])
;      (map string->number (string-split (read-line in)))))

;    ;; Read field values
;    (define field-values
;     (for/list ([f (in-list field-names)])
;      (for/list ([i (in-range num-points)])
;       (string->number (read-line in)))))

;    ;; Return structured data
;    (hash 'version version
;       'dimension dimension
;       'points coords
;       'fields (map cons field-names field-values)))))
