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
                  'magit-status))

(my-global-keymap)

(provide 'my-keymap)




;;; End of file