## LISP

- [Recommended environment Portacle](https://portacle.github.io/)
- [Common LISP resources](https://lisp-lang.org/learn/getting-started/)
- [Tutorialspoint tutorial](https://www.tutorialspoint.com/lisp/index.htm)

### Tutorials

1. [Getting started](lisp/getting-started.lisp)

### Tips

- Who do I produce an executable from within the REPL?

```lisp
; For Windows use the `.exe` otherwise it won't execute!
(save-lisp-and-die "myapp.exe" :executable t :toplevel #'main)
```
