;;;; My keymap file
;;; Please note that this takes advantage of a custom xmodmap that gives
;;; me 3 extra modifier keys (Alt, Hyper, Super) in addition to the
;;; defaults (Control, Meta, Shift).

;;;; Global map
(defun my-global-keymap ()
  "Defines all my global keybindings."
  (interactive)
  (global-set-key [(control ?\;)]
                  'comment-dwim)
  (global-set-key [(super ?\ )]
                  'ido-switch-buffer)
  (global-set-key [(super ?\f)]
                  'ido-find-file)
  ;;; magit
  (global-set-key [(control ?\c) ?\p]
                  'magit-status)
  (global-set-key [(super ?\p)]
                  'magit-status)
  (global-set-key [(hyper ?\ )]
                  'slime-selector))

;; C-j is a terrible binding for lisp modes, its normally mapped to
;; eval-print-last-sexp by the _major_ mode.
(define-key paredit-mode-map [(control ?\j)] nil)

(my-global-keymap)

(provide 'my-keymap)




;;; End of file