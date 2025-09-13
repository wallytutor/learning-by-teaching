;; First steps with Lisp
(format t "~%* Hello, LISP!~% ")

(defun hellolisp() 
    "Hello, World! But as a function."
    (format t "~%* Hello, World!~%"))

(defun fib (n)
  "Return the nth Fibonacci number."
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

; (funcall #'fib 30)
; (apply #'fib (list 30))

(defun main ()
    (hellolisp)
    (fib 30))

; (save-lisp-and-die "getting-started.exe" :executable t :toplevel #'main)