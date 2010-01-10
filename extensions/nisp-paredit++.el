;;; nisp-paredit++ --- Paredit extensions
;;; Copyright (c) 2010 Nixeagle
;;; Released under GNU GPLv3
;;; Commentary:
;; Modified from README.Debian for paredit and modified to add a
;; frequent value intead of actually adding to the hook.

;;; Code:

(when (fboundp 'paredit-mode)
      (mapc (lambda (hook)
              (custom-add-frequent-value hook (lambda () (paredit-mode +1))))
            '(lisp-mode-hook scheme-mode-hook)))


(provide 'nisp-paredit++)
;;; nisp-paredit++.el ends here