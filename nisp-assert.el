;;; nisp-assert -- Assertions for testing elisp
;;; Copyright (c) 2010 Nixeagle
;;; Released under GNU GPLv3 or later
;;; Commentary:
;; These assertions all use a very different form of argument display:
;; It looks something like this:
;;   (string= [(concat "a" "b") => "ab"] ["b" => "b"])
;; Of course this example is for string assertions only.
;;; Code:

(eval-when-compile
  (require 'cl))

(defmacro nisp-assert-string= (s1 s2)
  "Assert that S1 is `string=' to S2."
  `(assert (string= ,s1 ,s2) nil
           "string= assertion failed:
 (string= [%S => %S] [%S => %S])

"
           ',s1 ,s1 ',s2 ,s2))

(defmacro nisp-assert-many-string= (single-string &rest strings)
  "Assert that STRINGS all are `string=' to SINGLE-STRING."
  (declare (indent 1))
  (let ((s1 (gensym)))
    `(let ((,s1 ,single-string))
       (progn ,s1 ,@(mapcar (lambda (t1)
                              `(nisp-assert-string= ,s1 ,t1))
                            strings)))))

(defmacro nisp-assert-many (macro-assertion single-form &rest forms)
  "Assert that FORMS all are MACRO-ASSERTION to SINGLE-FORM."
  (declare (indent 1))
  (let ((s1 single-form))
    `(progn ,@(mapcar (lambda (t1)
                        (list macro-assertion s1 t1))
                      forms))))

(provide 'nisp-assert)
;;; nisp-assert.el ends here