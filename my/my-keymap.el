;;;; My keymap file
;;; Please note that this takes advantage of a custom xmodmap that gives
;;; me 3 extra modifier keys (Alt, Hyper, Super) in addition to the
;;; defaults (Control, Meta, Shift).

;;;; Global map
(defun my-global-keymap ()
  "Defines all my global keybindings."
  (interactive)
  (global-set-key (kbd "C-;")
                  'comment-dwim)
  (global-set-key (kbd "s-SPC")
                  'ido-switch-buffer)
  (global-set-key (kbd "s-f")
                  'ido-find-file)

  ;;; magit
  (global-set-key (kbd "C-c p")         ;console
                  'magit-status)
  (global-set-key (kbd "s-p")           ;X
                  'magit-status)
)

(my-global-keymap)

(provide 'my-keymap)

;;; End of file