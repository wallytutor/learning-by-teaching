#lang racket

(define-syntax-rule (show-hash h key)
  (printf "~a = ~a\n" 'key (hash-ref h 'key)))

(define (make-ip-hash data-version dimensions num-points)
    (hash 'version    data-version
          'dimensions dimensions
          'points     num-points))

(define (print-head h)
  (show-hash h version)
  (show-hash h dimensions)
  (show-hash h points))

(define (parse-number fp)
  (string->number (string-trim (read-line fp))))

(define (read-interpolation-file file-path)
  (call-with-input-file file-path
    (lambda (fp)
      (define data-version (read-line fp))
      (define dimensions   (parse-number fp))
      (define num-points   (parse-number fp))
      (define num-vars     (parse-number fp))
      ; (printf "~a \n" num-vars)

      ; (define field-names
      ;   (for/list ([i (in-range num-vars)])
      ;     (read-line fp)))
      ; (printf "~a \n" field-names)

      (make-ip-hash data-version dimensions num-points))))

;; (define h (make-ip-hash "3" 2 5))
(define h (read-interpolation-file "sandbox-sample.ip"))
(print-head h)


; (define (read-interpolation-file path)
;  (call-with-input-file path
;   (lambda (in)
;    (define version (read-line in))
;    (define dimension (string->number (read-line in)))
;    (define num-points (string->number (read-line in)))
;    (define num-fields (string->number (read-line in)))
;    (define field-names (string-split (read-line in)))

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

