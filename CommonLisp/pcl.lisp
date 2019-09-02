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

;; Chapter 3

;; plist
(list :a 1 :b 2 :c 3) ; plist
(getf (list :a 1 :b 2 :c 3) :a) ; -> 1

(defvar *db* nil) ; define a global variable
(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))
(make-cd "Roses" "Kathy Mattea" 7 t)
(defun add-record (cd)
  (push cd *db*))
(add-record (make-cd "Roses" "Kathy Mattea" 7 t))
(add-record (make-cd "Fly" "Dixie Chichks" 8 t))
(add-record (make-cd "Home" "Dixie Chichks" 9 t))
(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a:~10t~a~%~}~%" cd)))
(defun prompt-read (prompt)
  (format *query-io* "~a:" prompt)
  (force-output *query-io*)
  (read-line *query-io*))
(defun promp-for-cd ()
  (make-cd (prompt-read "Title")
	   (prompt-read "Artist")
	   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
	   (y-or-n-p "Ripped [y/n]")))
(defun add-cds ()
  (loop (add-record (promp-for-cd))
     (if (not (y-or-n-p "Another? [y/n]: ")) (return))))
(defun save-db (filename)
  (with-open-file (out filename
		       :direction :output
		       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))
(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))
(defun select (select-fn)
  (remove-if-not select-fn *db*))
(defun title-selector (title)
  #'(lambda (cd) (equal (getf cd :title) title))) 
;; (select (title-selector "Fly"))
(defun where (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
      (and (if title (equal (getf cd :title) title) t)
	   (if artist (equal (getf cd :artist) artist) t)
	   (if rating (equal (getf cd :rating) rating) t)
	   (if ripped-p (equal (getf cd :ripped) ripped) t))))
	   
(defun update (select-fn &key title artist rating (ripped nil ripped-p))
  (setf *db*
	(mapcar #'(lambda (cd)
		    (when (funcall select-fn cd)
		      (if title (setf (getf cd :title) title))
		      (if artist (setf (getf cd :artist) artist))
		      (if rating (setf (getf cd :rating) rating))
		      (if ripped-p (setf (getf cd :ripped) ripped)))
		    cd)
		*db*)))
(defun delete-cds (select-fn)
  (setf *db*
	(remove-if select-fn *db*)))

(defun make-cmp-expr (field value)
  `(equal (getf cd ,field) ,value))
(defun make-cmp-list (fields)
  (loop while fields
     collecting (make-cmp-expr (pop fields) (pop fields))))
(defmacro where-2 (&rest clauses)
  `#'(lambda (cd) (and ,@(make-cmp-list clauses))))

;; Chapter 5

#|
Function:

(defun name (parameter*)
  "Optional documentation string."
  body-form*)

- Optional parameters
(defun foo (a b &optional c d) (list a b c d)
(foo 1 2) -> (1 2 nil nil)
(foo 1 2 3) -> (1 2 3 nil)
(foo 1 2 3 4) -> (1 2 3 4)

(defun foo (a &optional (b 10)) (list a b))
(foo 1) -> (1 10)
(foo 1 2) -> (1 2)

(defun foo (a &optional (b a)) (list a b))
(foo 1) -> (1 1)
(foo 1 2) -> (1 2)

(defun foo (a &optional b (c 3 c-supplied-p)) (list a b c c-supplied-p))
(foo 1 2) -> (1 2 3 nil)
(foo 1 2 3) -> (1 2 3 T)
(foo 1 2 4) -> (1 2 4 T)

- Rest parameters

(defun foo (a &rest values) (list a values))
(foo 1) -> (1 nil)
(foo 1 2) -> (1 (2))
(foo 1 2 3) -> (1 (2 3))

- Keyword Parameters
(defun foo (&key a b c) (list a b c)
(foo) -> (nil nil nil)
(foo :a 1) -> (1 nil nil)
(foo :b 1) -> (nil 1 nil)
(foo :c 1) -> (nil nil 1)
(foo :a 1 :c 3) -> (1 nil 3)
(foo :a 1 :b 2 :c 3) -> (1 2 3)
(foo :a 1 :c 3 :b 2) -> (1 2 3)

(defun foo (&key ((:apple a)) ((:box b) 0) ((:charlie c) 0 c-supplied-p))
  (list a b c c-supplied-p))
(foo :apple 10 :box 20 :charlie 30) -> (10 20 30 T)

- function as data

(function foo)
#'foo

(foo 1 2 3) = (funcall #'foo 1 2 3) = (apply #'foo (1 2 3))

- Anonymous functions
(lambda (parameters) body)
(funcall #'(lambda (x y) (+ x y)) 1 2) -> 3

|#

;; Chapter 6

#|

- Variables
(defun foo (x y z) (+ x y z))
x, y, z are variables

(let (variable*)
  body-form*)

- Lexcical Variables and Closures
(defparameter *fn*
  (let ((count 0))
    #'(lambda () (setf count (1+ count)))))

(funcall *fn*) -> 1
(funcall *fn*) -> 2
(funcall *fn*) -> 3

(let ((count 0))
  (list
   #'(lambda () (incf count))
   #'(lambda () (decf count))
   #'(lambda () count)))

- Dynamic Variables
global variables:
  - defvar: only assigns the initial value if the variable is undefined
  - defparameter: always assigns the initial value to the variable

(defvar *x* 10)
(defun foo () (format t "X: ~d~%" *x*))
(foo)  -> "X: 10"
(let ((*x* 20)) (foo)) -> "X: 20"

- Constants
(defconstant name initial-value-form [ documentation-string ])

- Assignment
(setf place value)

Simple variable:    (setf x 10)
Array:              (setf (aref a 0) 10)
Hash Table:         (setf (gethash 'key hash) 10)
Slot named 'field': (setf (field o) 10)

(rotatef a b) -> swap the values of two variables, return nil
(shiftf a b 10) -> a=b and b=10, return old value of a


|#

;; Chapter 7
#|
Standard Control Constructs

- if
(if condition then-form [else-form])

- when
(defmacro when (condition &rest body)
  `(if ,condition (progn ,@body)))

- unless
(defmacro unless (condition &rest body)
  `(if (not ,condition) (progn ,@body)))

- cond
(cond
  (test-1 form*)
  ...
  (test-n form*))
(cond
  (a (do-x))
  (b (do-y))
  (t (do-z)))

- and or not
(not nil) -> T
(not (= 1 1)) -> nil
(and (= 1 2) (= 3 3)) -> nil
(or (= 1 2) (= 3 3)) -> T

- loop
(dolist (var list-form)
  body-form*)

(dotimes (var count-form)
  body-form*)


|#
