;;; nisp-eldoc++.el --- 
;; 
;; Filename: nisp-eldoc++.el
;; Description: 
;; Author: James
;; Maintainer:
;; Created: Thu Feb 11 23:19:38 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 5
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

(provide 'nisp-eldoc++)
(require 'eldoc)

(defun nisp-eldoc-function-elisp-variable-value
  (&optional n.symbol)
  "Return N.SYMBOL's value.

Meant to help show the value of a symbol in minibuffer."
  (symbol-value (or n.symbol (eldoc-current-symbol))))

(defun nisp-eldoc-function-format-function-symbol
  (&optional n.function-symbol)
  "Format N.FUNCTION-SYMBOL for display in minibuffer.

N.FUNCTION-SYMBOL should be a list of this form:
  (<function-symbol> <argument index>)

<function-symbol> should be the name of a function.
<argument index> should be the position of the current argument.

N.FUNCTION-SYMBOL defaults to `eldoc-fnsym-in-current-sexp'.

For example: (and 3) means point is in the 3rd argument to `and'.
In other words the situation looks like this: (and 1 2 |), where
| is the current location of point."
  (apply 'eldoc-get-fnsym-args-string
         (or n.function-symbol
             (eldoc-fnsym-in-current-sexp))))
;; Sample output.
;; #("nisp-eldoc-documentation-function-function-symbol: (&optional
;; #N.FUNCTION-SYMBOL)" 0 49 (face font-lock-function-name-face) 62 79
;; #(face eldoc-highlight-function-argument))

(defvar nisp-eldoc-ignorable-elisp-list
  '(and or defun defvar defmacro defparameter defconst defcustom)
  "Functions eldoc should not print arglist information.")

(defun nisp-eldoc-ignorable-elisp-p (&optional n.function)
  "True if N.FUNCTION should not display arglist information.

Functions to ignore are in `nisp-eldoc-ignorable-elisp-list'."
  (member (or n.function (eldoc-current-symbol))
          nisp-eldoc-ignorable-elisp-list))

(defun nisp-eldoc-documentation-function-elisp
  (&optional n.symbol n.function-symbol)
  "Print documentation information using `eldoc'.

This is called by `eldoc-print-current-symbol-info' by being
added to `eldoc-documentation-function'. The primary difference
is this function prints the current value of a global variable
instead of that variable's documentation string."
  (let ((n.symbol (or n.symbol (eldoc-current-symbol)))
        (n.function-symbol (or n.function-symbol
                               (eldoc-fnsym-in-current-sexp))))
    (let ((n.symbol-doc
           (and (boundp n.symbol)
                (nisp-eldoc-function-elisp-variable-value n.symbol)))
          (n.function-symbol-doc (nisp-eldoc-function-format-function-symbol
                                  n.function-symbol)))
      (eldoc-message
       (if (eq n.symbol (car n.function-symbol))
           (or n.symbol-doc n.function-symbol-doc)
         (or (when (nisp-eldoc-ignorable-elisp-p (car n.function-symbol))
                  n.function-symbol-doc)
             n.symbol-doc))))))

(setq eldoc-documentation-function 'nisp-eldoc-documentation-function-elisp)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-eldoc++.el ends here
