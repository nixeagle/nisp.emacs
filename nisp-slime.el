;;; nisp-slime.el ---
;;
;; Filename: nisp-slime.el
;; Description:
;; Author: James
;; Maintainer: James Nixeagle
;; Created: Wed Jan 13 17:33:31 2010 (+0000)
;; Version:
;; Last-Updated: Fri Jan 22 01:30:10 2010 (+0000)
;;           By: James
;;     Update #: 17
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
;; See git logs
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
(defun goto-sexp-end ()
  "Move point to the end of the current sexp"
  (end-of-defun)
  (backward-char))
;; point where "end of defun" is. Problem is its not really accurate.
;; its really end of next defun, where defun is anything other then spaces...
;; such as numbers, strings, and so on.
(defun nisp-end-of-defun (&optional p)
  (let ((p (or p (point))))
    (prog2 (end-of-defun)
        (point)
      (goto-char p))))

(defun nisp-beginning-of-defun (&optional p)
  (let ((p (or p (point))))
    (prog2 (beginning-of-defun)
        (point)
      (goto-char p))))

(defun nisp-after-closing-paren-p ()
  "Return `t' when point is after a ).

This ignores any whitespace that might exist."
  (save-match-data                      ;don't want to modify match data.
    (looking-back ")\s*")))
(defun my-slime-async-eval (expression ns func)
  "Eval EXPRESSION in `slime' and pass result to BODY.

Run EXPRESSION in NS. If nil, defaults to whatever is set.

Based off of `slime-eval-async'."
  (setq my-erc-var-CL-expression (substring-no-properties expression))

  (setq my-erc-var-CL-func func)
  (slime-eval-async
    `(swank:eval-and-grab-output ,my-erc-var-CL-expression)
    (lambda (result)
      (destructuring-bind (output value) result
        (funcall my-erc-var-CL-func
                 my-erc-var-CL-expression
                 output
                 value)))
    ns)
  nil)


(defun nisp-slime-filter-trace-buffer (buffer-as-string)
  "Remove unbalanced delimiters from BUFFER-AS-STRING."
  (replace-regexp-in-string "\\(%DOCUMENTATION\s*=\s\"[^\n\"]*\\)\n"
                            "\\1\"\n" buffer-as-string))

(defun make-slime-trace-buffer (in output err trace value &optional describe)
  "Make buffer with pretty print common lisp eval"
  (with-current-buffer (get-buffer-create "*NISP:EVAL*")
    (erase-buffer)
    (insert "=== describe ===\n")
    (let ((c 0))
      (mapc (lambda (x)
              (insert "------" (prin1-to-string (incf c)) "-----\n"
                      (nisp-slime-filter-trace-buffer x) "\n"))
            describe))
    (insert "=== output ===\n" out "\n")
    (insert "=== error ===\n" err "\n")
    (insert "=== trace ===\n" trace "\n")
    (insert "=== input ===\n" in "\n")
    (insert "=== result ===" val "\n")
    (goto-char (point-min))
    (lisp-mode))
  (display-buffer "*NISP:EVAL*" t))

(defun my-slime-pprint-eval-last-expression-extra (string)
  (interactive (list (slime-last-expression)))
  (slime-eval-async `(nix-emacs::nix-pprint-eval ,string t)
                    (lambda (result)
                      (destructuring-bind (in out err trace val d) result
                        (make-slime-trace-buffer in out err trace val d)))))

(defun my-slime-eval-last-expression (string)
  (interactive (list (slime-last-expression)))
  (slime-eval-async `(nix-emacs::nix-pprint-eval ,string t)
                    (lambda (result)
                      (destructuring-bind (in out err trace val d) result
;                        (insert  (replace-regexp-in-string "\\\n" "\n;;=> " val))
                        (make-slime-trace-buffer in out err trace val d)
                        (message "%s" (substring val 1))))))

(defun my-slime-eval-last-exprssion-into-current-buffer (string)
  "Evalutate the last expression before point.

This is special in that it replaces past results with the new
results and leaves point at the original place you invoked it."
  (interactive (let ((p (point)))
                 (goto-sexp-end)
                 (prog1 (list (slime-last-expression))
                   (goto-char p))))
  (slime-eval-async `(nix-emacs::nix-pprint-eval ,string t)
    (lambda (result)
      (destructuring-bind (in out err trace val d) result
        (let ((p (point)))
          (goto-sexp-end)
          (when (looking-at "\\(\\(\\\s*\n\\)*;;=> .*\n?\\)+")
            (replace-match ""))
          (insert
           (replace-regexp-in-string "\\\n" "\n;;=> " val)
           "\n")
          (goto-char p))))))



(defun nisp-slime-toggle-trace-fdefinition-no-query ()
  "Toggle tracing on the common lisp side.

This is a modified version of `slime-toggle-trace-fdefinition'
that does not prompt for which function to trace, it just does it.

No prompt means toggling trace on and off of a function using a
single key press is much smoother. If the wrong thing is toggled,
its easy enough to re-invoke the function.

Please note that the optional parameter using-context-p is set to
t with no option to override. If this is a problem, I will add it
back in but with it defaulting to t instead of nil."
  (interactive)
  (let ((spec (slime-symbol-at-point)))
    (message "%s" (slime-eval `(swank:swank-toggle-trace ,spec)))))


(provide 'nisp-slime)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-slime.el ends here
