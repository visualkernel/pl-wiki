;; list
'(rose voilet daisy buttercup)
;; some to 
'(rose
  violet
  daisy
  buttercup)

;; nested list
'(this list has (a list inside of it))

;;Evaluation
(+ 1 2) ;; 3
(+ 2 (+ 3 3)) ;; 8

;; Variables
fill-column ;; 70

;; <message> function: A message is printed in the echo area.
(message "This message appears in then echo area!")
;; use %s
(message "The name of this buffer is: %s." (buffer-name))
;; use %d
(message "This value of fill-column is %d." fill-column)

;; Setting the Value of a Variable
;; Using set
(set 'flowers '(rose violet daisy buttercap))
flowers ;; (rose voilet daisy buttercap)
'flowers ;; flowers
;; Using setq
(setq flowers '(rose violet daisy buttercap))
(setq name "Jack"
      age 10)
name ;; "Jack"
age ;; 10

;;Buffer
;;returns the name of the buffer
(buffer-name) ;; "eintr.el"
(buffer-file-name) ;; "/home/ice/work/03-github/visualkernel/pl-wiki/Elisp/eintr.el"

;; get the buffer itself
(current-buffer) ;; #<buffer eintr.el>
;; return the most recently selected buffer other than the one you are in currently
(other-buffer) ;; #<buffer *scratch*>
;; switch to a different buffer
(switch-to-buffer (other-buffer))

;;Buffer Size and the Location of Point
(buffer-size) ;; 1211
;; point: the current position of the cursor
(point) ;; 1269
(point-min) ;; 1
(point-max) ;;1309

;;The defun Macro
;; (defun function-name (arguments...)
;;   "optional-documentation..."
;;   (interactive argument-passing-info) ; optional
;;   body...)
(defun multiply-by-seven1 (number)
  "Multiply NUMBER by seven."
  (* 7 number))
(multiply-by-seven1 3) ;; 21
;;C-h f (describe-function): can read the documentation of a function
(describe-function #'multiply-by-seven1)

(defun multiply-by-seven2 (number)
  "MUltiply NUMBER by seven."
  (interactive "p")
  (message "The result is %d" (* 7 number)))
;; C-u 3 M-x multiply-by-seven2
;; (interactive "p") => "p" tells Emacs to pass the prefix argument to the function
;; and use its value for the argument of the function

;;The let Speical Form
;; (let ((variable value)
;;       (variable value)
;;       ...)
;;   body...)
(let ((birch 3)
      pine
      fir
      (oak 'some))
  (message
   "Here are %d variables with %s, %s, and %s value."
   birch pine fir oak)) ;; "Here ware 3 variables with nil, nil, and some value."

;;The if Speical Form
;; (if test                        ;test-part
;;     action-if-test-is-true)     ;then-part
;;
;; (if test                        ;test-part
;;     action-if-test-is-true      ;then-part
;;   actoin-if-test-is-false)      ;else-part
(if (> 5 4)
    (message "5 is greater than 4!"))
(if (> 4 5)
    (message "4 is greater than 5!")
  (message "4 is not greater than 5!"))
(> 4 5) ;; nil
(> 5 4) ;; t

;; save-excursion special form
;; The save-excursion special form saves the location of point and restores
;; this position after the body is evaluated by the Lisp interpreter.
;; (save-excursion
;;   body...)

(defun simplified-beginning-of-buffer ()
  "Move point to the beginning of the buffer;
leave mark at previous position."
  (interactive) ;; the function can be used interactively.(M-x simplified-beginning-of-buffer)
  (push-mark)  ;; set a mark at the current position of the cursor
  (goto-char (point-min))) ;; jumps the cursor to the minimum point in the buffer
;;(point-min): beginning of buffer
;;(point-max): end of buffer

(defun mark-whole-buffer ()
  "Put point at beginning and mark at end of buffer."
  (interactive)
  (push-mark (point))
  (push-mark (point-max) nil t)
  (goto-char (point-min)))

