;; Start by selecting the language:
#lang slideshow

;; Expressions are printed directly:
5
"art gallery"

;; Function calls are also expressions:
(circle 10)
(rectangle 10 20 #:border-color "red")

;; Try to introduce an error:
; (circle 10 20)

;; Declare some variables and use them:
(define my-circ (circle 10))
(define my-rect (rectangle 20 20))
(cc-superimpose my-circ my-rect)

;; Test hc-append with optional arguments:
(hc-append 20 my-circ my-rect my-circ)

;; Define a new function for assembly:
(define (square-with-hole side)
  (cc-superimpose
   (circle (- side 10))
   (rectangle side side)))

(square-with-hole 100)
