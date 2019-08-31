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
