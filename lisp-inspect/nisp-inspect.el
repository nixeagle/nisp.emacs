;;; nisp-inspect.el --- lisp inspection, sorta
;;
;; Filename: nisp-inspect.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Thu Jan 14 00:18:44 2010 (+0000)
;; Version: 0.0.1
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
(require 'nisp-assert)

(defun nisp-filter-trace-buffer (buffer-as-string)
  "Remove unbalanced delimiters from BUFFER-AS-STRING."
  (replace-regexp-in-string "\\(%DOCUMENTATION\s*=\s\"[^\n\"]*\\)\n"
                            "\\1\"\n" buffer-as-string))

(defun nisp-inspect-set-default-local-variables ()
  "Set the default buffer local variables."
  (setq major-mode 'nisp-inspect-mode)
  (setq mode-name "Nisp Inspect"))

(defun nisp-inspect-mode-make-keymap ()
  "Return a fresh keymap for `nisp-inspect-mode'."
  (let ((map (make-sparse-keymap)))
    map))

;; Deviating from the manual because what it suggests is ugly and
;; defining my own function and calling it inside a defvar does the same
;; thing and is easier to read.
(defvar nisp-inspect-mode-map (nisp-inspect-mode-make-keymap)
  "Major mode mode map.")


(defun nisp-inspect-mode ()
  "Turn on interactive lisp inspection mode."
  ;; Needs to switch to new mode, setup syntax table, keymap and buffer
  ;; local variables without changing the contents of the buffer.
  ;;
  ;; Documentation string needs to contain a list of the special
  ;; commands a user would be interested in.
  (interactive)

  ;; Manual says "call this first", so we do.
  (kill-all-local-variables))

(provide 'nisp-inspect)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-inspect.el ends here
