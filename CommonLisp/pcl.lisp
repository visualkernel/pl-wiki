;;Chapter 2

#||
funciton definition:

(defun name (parameter*)
  (body*))
or
(defun name varlist &rest body)
||#
(defun hello-world ()
  (format t "hello, world"))

#||
use LOAD function 
||#
(load "hello.lisp")
T
;; or
(load (compile-file "hello.lisp"))
; compiling file "/home/ice/work/03-github/visualkernel/pl-wiki/CommonLisp/hello.lisp" (written 17 AUG 2019 09:19:43 PM):
; compiling "hello world"
; compiling (FORMAT T ...)
; compiling (DEFUN HELLO ...)

; /home/ice/work/03-github/visualkernel/pl-wiki/CommonLisp/hello.fasl written
; compilation finished in 0:00:00.002
T
