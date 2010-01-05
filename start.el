
(defvar *nisp-load-path* "~/.emacs.d/nisp.emacs"
  "Default base for nisp.

If the repository is cloned to another path, change this to
reference the root project directory of nisp.")

(defun make-nisp-path (&optional file-or-subdir)
  "Prepend FILE-OR-SUBDIR with base for nisp."
  (concat (file-name-as-directory *nisp-load-path*)
          file-or-subdir))

;;; Set and load emacs customize settings.
(setq custom-file (make-nisp-path "custom/my-custom.el"))
(load custom-file)

;;; Setup some load paths
(defun nisp-add-to-load-path (directory)
  "Add DIRECTORY to `load-path' after checking it exists."
  (when (file-directory-p directory)
    (add-to-list 'load-path directory)))

(nisp-add-to-load-path *nisp-load-path*)
(nisp-add-to-load-path (make-nisp-path "my"))
(nisp-add-to-load-path (make-nisp-path "3rd-party/jwiegley-magit"))


;;;; Requires
;;; Lets try loading the keymap first
(require 'my-keymap)

;;; Include and turn on ido-mode
(require 'ido)
(ido-mode 1)

;;; Include magit. This is a special submodule
(require 'magit)

;;; basically some org mode hooks I wrote the other day right now
(require 'nisp-old)
