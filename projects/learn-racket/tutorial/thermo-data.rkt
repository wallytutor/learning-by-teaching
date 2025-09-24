#lang racket

; Exported from module
(provide shomate database)

; Defines a basic data structure for Shomate thermodynamics data:
(struct shomate-data (a b c d e f g h))

; Assembles data structure for a species represented with Shomate data
(struct shomate-species (name data))

(define-syntax-rule [shomate name data]
  (lambda (stx)
    (let ([expr (syntax-e stx)])
      (if (or (symbol? expr) (< (length expr) 3))
        (raise-syntax-error #f "must be an expression" stx)
        #'(shomate-species (name (shomate-data (data))))
      ))))

; (define data-al2o3 (shomate "AL2O3" (list 1.024290e+02  3.874980e+01 -1.59109e+01 
;                                           2.628181e+00 -3.007551e+00 -1.71793e+03
;                                           1.469970e+02 -1.675690e+03)))

; (define data-al2o3 (apply shomate-data (list 1.024290e+02  3.874980e+01 -1.59109e+01 
;                                              2.628181e+00 -3.007551e+00 -1.71793e+03
;                                              1.469970e+02 -1.675690e+03)))
; (define compound-al2o3 (shomate-species "AL2O3" data-al2o3))

; (shomate-species-name compound-al2o3) 

(define datbase ())
