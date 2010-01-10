;;; nisp-paredit++ --- Paredit extensions
;;; Copyright (c) 2010 Nixeagle
;;; Released under GNU GPLv3
;;; Commentary:
;; Modified from README.Debian for paredit and modified to add a
;; frequent value intead of actually adding to the hook.

;;; Code:

;;This function is from paredit.el Version 20 (beta)
;;
;;We have to include this here because debian sid as of 10-01-2010 does
;;not autoload this.
(defun enable-paredit-mode ()
  "Turn on pseudo-structural editing of Lisp code.

Deprecated: use `paredit-mode' instead."
  (interactive)
  (paredit-mode +1))

(when (fboundp 'paredit-mode)
      (mapc (lambda (hook)
              (custom-add-frequent-value hook 'enable-paredit-mode))
            '(lisp-mode-hook scheme-mode-hook emacs-lisp-mode-hook)))


(provide 'nisp-paredit++)
;;; nisp-paredit++.el ends here