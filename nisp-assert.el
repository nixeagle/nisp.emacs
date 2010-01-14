;;; nisp-assert.el ---
;;
;; Filename: nisp-assert.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Thu Jan 14 00:22:58 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 1
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
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
(defmacro nisp-assert-build-arg-pair (form)
  `(cons ',(symbol-value form) ,(symbol-value form)))

(defun nisp-assert-build-arg-pairs (args)
  "Return dotted pairs of ARGS and their results."
  `(,@(mapcar (lambda (x)
              (nisp-assert-build-arg-pair x))
          args)))

(defmacro footest (args)
  ``(,@(nisp-assert-build-arg-pairs ,args)))

;; (macroexpand '(footest ((+ 1) (+ 1 2))))
;; (list
;;  ((+ 1)
;;   . 1)
;;  ((+ 1 2)
;;   . 3))

(defun nisp-cars (&rest args)
  "Return the `car' for each dotted pair in ARGS."
  (mapcar 'car (or (and (consp (cadr args)) args)
                   (car args))))

(defmacro nisp-assert-predicate (predicate &rest args)
  "`assert' PREDICATE called with ARGS."
  (declare (indent 1))
  (let ((pairs (nisp-assert-build-arg-pairs args)))
    `',pairs))

;    `(assert (,predicate ,@(nisp-cars pairs)) nil)

;(macroexpand '(nisp-assert-predicate string= 1 2 3))
              ;  (format "%s assertion failed: (%s %S)"
               ;    ,predicate ,predicate
;)))))

(defun nisp-assert-format-arg (arg value)
  "Format ARG and VALUE as a string.

Remember if ARG is an expression, pass it quoted."
  (format "[%S => %S]" arg value))

(defmacro nisp-assert-many-string= (single-string &rest strings)
  "Assert that STRINGS all are `string=' to SINGLE-STRING."
  (declare (indent 1))
  (let ((s1 (gensym)))
    `(let ((,s1 ,single-string))
       (progn ,@(mapcar (lambda (t1)
                          `(nisp-assert-string= ,s1 ,t1))
                        strings)))))

(defmacro nisp-assert-many (macro-assertion single-form &rest forms)
  "Assert that FORMS all are MACRO-ASSERTION to SINGLE-FORM."
  (declare (indent 1))
  (let ((s1 (gensym)))
    `(let ((,s1 ,single-form))
       (progn ,@(mapcar (lambda (t1)
                          (list macro-assertion s1 t1))
                        forms)))))

(provide 'nisp-assert)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-assert.el ends here
