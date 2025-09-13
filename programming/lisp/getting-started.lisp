;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;; FIRST STEPS WITH LIPS
;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(format t   "(1) Hello, World!~%")
(write-line "(2) Hello, World!")

(defun hellolisp() 
    "Hello, World! But as a function."
    (format t "(3) Hello, World!~%"))

(defun main ()
    "Extended `Hello, World!` with a function definition."    
    (hellolisp))

(main)

;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;; SHOMATE THERMODYNAMICS DATA
;;
;; Study test with data from the following sources:
;; https://webbook.nist.gov/cgi/cbook.cgi?ID=C1344281&Type=JANAFS&Table=on#JANAFS
;; https://webbook.nist.gov/cgi/cbook.cgi?ID=C14808607&Type=JANAFS&Table=on#JANAFS
;; for computing properties of Al2O3; this provides a good tutorial case for learning the basics
;; of arithmetic operations, function definition, data storage. We also see how to create a new
;; data structure, create instances, and use them with a user-defined function.
;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(defstruct shomate-data name coefficients)

(defconstant database (list
    (make-shomate-data
        :name "AL2O3"
        :coefficients (list  1.0242900e+02  3.874980e+01 -1.591090e+01  2.628181e+00
                            -3.0075510e+00 -1.717930e+03  1.469970e+02 -1.675690e+03))
    (make-shomate-data
        :name "SIO2 (Quartz - alpha)"
        :coefficients (list -6.0765914e+00  2.516755e+02 -3.247964e+02  1.685604e+02
                             2.5480000e-03 -9.176893e+02 -2.796962e+01 -9.108568e+02))
))

(defun specific-heat-shomate (coefs temp)
    (let ((tr (/ temp 1000))
          (A (nth 0 coefs))
          (B (nth 1 coefs))
          (C (nth 2 coefs))
          (D (nth 3 coefs))
          (E (nth 4 coefs)))
    (+ A (* tr (+ B (* tr (+ C (* D tr))))) (/ E (* tr tr)))))

(defun eval-specific-heat-shomate (species temp)
    (specific-heat-shomate (shomate-data-coefficients species) temp))

(write-line (shomate-data-name (nth 0 database)))
(write-line (shomate-data-name (nth 1 database)))

(print (eval-specific-heat-shomate (nth 0 database) 1000.0)) ; 124.9
(print (eval-specific-heat-shomate (nth 1 database)  800.0)) ; 73.70
