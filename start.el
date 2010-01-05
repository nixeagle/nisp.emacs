

;;; Set and load emacs customize settings.
(setq custom-file "~/.emacs.d/nisp.emacs/custom/my-custom.el")
(load custom-file)

;;; Setup some load paths
(add-to-list 'load-path "~/.emacs.d/nisp.emacs/")
(add-to-list 'load-path "~/.emacs.d/nisp.emacs/my")
(add-to-list 'load-path "~/.emacs.d/nisp.emacs/3rd-party/jwiegley-magit")


;;; Now begin loading in custom lisp.
(load "~/.emacs.d/nisp.emacs/nisp-old.el")

;;;; Requires
;;; Lets try loading the keymap first
(require 'my-keymap)

;;; Include and turn on ido-mode
(require 'ido)
(ido-mode 1)

;;; Include magit. This is a special submodule
(require 'magit)