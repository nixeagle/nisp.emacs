;;; nisp-util.el ---
;;
;; Filename: nisp-util.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Thu Feb 18 09:08:25 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 4
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

(defun nisp-clean-whitespace (n.string)
  "Strip all newlines and multiple spaces from N.STRING."
  (replace-regexp-in-string "^\s+\\|\s+$" ""
                            (replace-regexp-in-string "[\s\n]+" " " n.string)))


(defun nisp-file-contents->string (n.filespec)
  "Return N.FILESPEC's contents as a string."
  (with-temp-buffer
    (insert-file-contents n.filespec)
    (buffer-string)))

(provide 'nisp-util)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-util.el ends here
