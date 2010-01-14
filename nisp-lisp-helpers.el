;;; nisp-lisp-helpers.el ---
;;
;; Filename: nisp-lisp-helpers.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Thu Jan 14 14:47:14 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 8
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

(defun nisp-lisp-set-common-lisp-indent ()
  "Set `lisp-indent-function' to `common-lisp-indent-function'."
  ;; The meant to set on a load hook to set this bufferlocal.
  (make-local-variable 'lisp-indent-function)
  (setq lisp-indent-function 'common-lisp-indent-function))

(custom-add-frequent-value 'lisp-mode-hook
                           'nisp-lisp-set-common-lisp-indent)

(defun nisp-kill-line (&optional arg)
  "Kill a line differently depending on major-mode."
  (interactive "P")
  (cond
   (paredit-mode (paredit-kill arg))
   (t (kill-line arg))))

(defun nisp-paredit-kill-and-join-forward (&optional arg)
  "Kill the line with `paredit-kill' and remove any spaces."
  (interactive "P")
  (paredit-kill arg)
  (fixup-whitespace)
  (indent-for-tab-command arg))


;; Taken from emacswiki discussion and modified
(defun kill-and-join-forward (&optional arg)
  "If at end of line, join with following; otherwise kill line.
     Deletes whitespace at join."
       (interactive "P")
       (when (and (eolp) (not (bolp)))
         (delete-indentation t)
         (when (looking-at " $")
           (delete-char 1))
         (nisp-kill-line arg)))


(provide 'nisp-lisp-helpers)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-lisp-helpers.el ends here
