;;; nisp-erc-no-header-line.el ---
;;
;; Filename: nisp-erc-no-header-line.el
;; Description:
;; Author: Nixeagle
;; Maintainer:
;; Created: Wed Feb 17 04:55:49 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 2
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;; Redefine a single function to tell erc to leave the headerline alone.
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;;                    Version 2, December 2004
;;
;; Copyright (C) 2010 Nixeagle
;;
;; Everyone is permitted to copy and distribute verbatim or modified
;; copies of this license document, and changing it is allowed as long
;; as the name is changed.
;;
;;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;;
;;  0. You just DO WHAT THE FUCK YOU WANT TO.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:
(require 'erc)

(defadvice erc-update-mode-line-buffer
  (around erc-update-mode-line-buffer-no-header-line-advice activate)
  "Unbind `header-line-format' and rebind it after the header is updated."
  (let ((temporary.header-line-format header-line-format))
    (makunbound 'header-line-format)
    ad-do-it
    (setq header-line-format temporary.header-line-format)))


(provide 'nisp-erc-no-header-line)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-erc-no-header-line.el ends here
