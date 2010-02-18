;;; nisp-org-util.el ---
;;
;; Filename: nisp-org-util.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Thu Feb 18 09:51:55 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 9
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Note that any function that starts with @ is experimental and or
;; incomplete.
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
(require 'nisp-util)
(require 'cl)

(defun nisp-org-back-to-heading ()
  "Move point to start of current heading."
  (org-back-to-heading t))

(defun @nisp-org-heading-components ()
  "Alist of `org-heading-components' data."
  (let ((components (cdr (org-heading-components))))
    `((level . ,(pop components))
      (todo . ,(pop components))
      (priority . ,(pop components))
      ;; There is a real problem with these last two.
      ;; `org-heading-components' will not tell us if we have a headline
      ;; or just a group of tags. So it is possible that headine is really
      ;; the tags.
      (headline . ,(pop components))
      (tags . ,(pop components)))))

(defun* @nisp-org-collect-tree (&key buffer file
                                    (point (point)))
  (unless (or buffer file)
    (let ((result-list ()))
      (org-map-tree (lambda () (push (point) result-list)))
      (nreverse result-list))))

(defun* nisp-org-all-targets (&key radio-targets-only-p file buffer)
  "List targets in FILE, BUFFER or default to `current-buffer'.

Returns only radio targets if RADIO-TARGETS-ONLY-P is t."
  (cond
   (buffer (with-current-buffer (get-buffer buffer)
             (org-all-targets radio-targets-only-p)))
   (file (with-temp-buffer
           (insert-file-contents file)
           (org-all-targets radio-targets-only-p)))
   (t (org-all-targets radio-targets-only-p))))


(defun nisp-org-clock-active-p (&optional clock)
  "True if org-clock is running.

This is a thin wrapper around `org-clock-is-active' that treats
it as a proper predicate."
  (and (not (not (org-clock-is-active)))
       (if clock                        ;Only if clock is not nil
           (org-is-active-clock clock)
         t)))

(provide 'nisp-org-util)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-org-util.el ends here
