;;;;;;; Nisp start file.
;;;;;;; Copyright (c) 2010 Nixeagle
;;;;;;; reuse is granted under GPLv3 or later

;;;; Customize stuff
;;; We do the main nisp customization group and variables first. Little
;;; to no chance of errors here.
(defconst *nisp-version* "0.0.13"
  "Nusp version.")
(defvar *nisp-root-parent-group* 'emacs
  "*Parent group of the group `nisp'.

This is customizable for the only reason that I like to quickly
reach my group from `custmize-browser' for testing defcustom
elements. The normal user setting for this will likely be
`local' (or some other sensible setting).")

(defgroup nisp nil
  "Nixeagle's lisp."
  :version "0.0.13"                     
  :group 'emacs)
(defgroup nisp-paths nil
  "Load path settings."
  :version "0.0.13"
  :group 'nisp)

;;;; "Bootstrap"
;;;We have to setup where we are in relation to the file system before
;;;much anything else can be done. This file is what is to be required
;;;from .emacs or .emacs.d/init.el
;;;
;;;What we do is make it possible to generate a load path from here out
;;;and then go load nisp-load-helper which defines more utilities
;;;related to loading emacs files.
(defvar *nisp-load-path* "~/.emacs.d/nisp.emacs"
  "Default base for nisp.

If the repository is cloned to another path, change this to
reference the root project directory of nisp.")

(defun nisp-make-path (&optional file-or-subdir)
  "Prepend FILE-OR-SUBDIR with base for nisp."
  (concat (file-name-as-directory *nisp-load-path*)
          file-or-subdir))

(defun nisp-add-to-load-path (directory)
  "Add DIRECTORY to `load-path' after checking it exists."
  (when (file-directory-p directory)
    (add-to-list 'load-path directory)))

;;; Set and load emacs customize settings.
(setq custom-file (nisp-make-path "custom/my-custom.el"))
(load custom-file)

;;; Setup some load paths
(nisp-add-to-load-path *nisp-load-path*)
(nisp-add-to-load-path (nisp-make-path "my"))
(nisp-add-to-load-path (nisp-make-path "3rd-party/jwiegley-magit"))


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
