

;;; Set and load emacs customize settings.
(setq custom-file "~/.emacs.d/nisp.emacs/custom/my-custom.el")
(load custom-file)

;;; Setup some load paths
(add-to-list 'load-path "~/.emacs.d/nixp.emacs")
(add-to-list 'load-path "~/.emacs.d/nixp.emacs/my")
(add-to-list 'load-path "~/.emacs.d/nisp.emacs/3rd-party/jwiegley-magit")


;;; Now begin loading in custom lisp.
(load "~/.emacs.d/nisp.emacs/nisp-old.el")

(require 'magit)