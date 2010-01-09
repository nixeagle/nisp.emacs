;;;;;;; Nisp start file.
;;;;;;; Copyright (c) 2010 Nixeagle
;;;;;;; reuse is granted under GPLv3 or later

;;;; Customize stuff
;;; We do the main nisp customization group and variables first. Little
;;; to no chance of errors here.
(defconst *nisp-version* "0.0.14"
  "Nusp version.")

(defvar *nisp-root-parent-group* 'emacs
  "*Parent group of the group `nisp'.

This is customizable for the only reason that I like to quickly
reach my group from `custmize-browser' for testing defcustom
elements. The normal user setting for this will likely be
`local' (or some other sensible setting).")

(defgroup nisp nil
  "Nixeagle's lisp."
  :group 'emacs)
(defgroup nisp-paths nil
  "Load path settings."
  :group 'nisp)

;;;; "Bootstrap"
;;;We have to setup where we are in relation to the file system before
;;;much anything else can be done. This file is what is to be required
;;;from .emacs or .emacs.d/init.el
;;;
;;;What we do is make it possible to generate a load path from here out
;;;and then go load nisp-load-helper which defines more utilities
;;;related to loading emacs files.
(defcustom nisp-load-path "~/.emacs.d/nisp.emacs"
  "default base for nisp.

If the repository is cloned to another path, change this to
reference the root project directory of nisp."
  :group 'nisp-paths
  :type '(directory))

;; (defcustom *nisp-toplevel-aliases* nil
;;   "Symbols that should be accessable at the top level of `nisp'."
;;   :group 'nisp
;;   ;; Really should be (member function symbol)
;;   ;; as lambda expressions are invalid.
;;   :type '(choice nil (list function)))

(defun nisp-make-path (&optional file-or-subdir)
  "Prepend FILE-OR-SUBDIR with base for nisp."
  (concat (file-name-as-directory nisp-load-path)
          file-or-subdir))

(defun nisp-add-to-load-path (directory)
  "Add DIRECTORY to `load-path' after checking it exists."
  (when (file-directory-p directory)
    (add-to-list 'load-path directory)))

(defvar *nisp-use-toplevel-for-interactive-functions* t
  "Do not prefix nisp- to (some) interactive commands when non-nil.

I like some of my commands right at the top level without the
need for the prefix. However I understand why this is not a sane
thing for everyone to do. Later I'll change to a list of
functions to use defalias on to remove the prefix and default
this to the empty list.")

;;; Set and load emacs customize settings
(defvar *nisp-custom-path* (nisp-make-path "custom")
  "Directory that contains all user settings.")

;;; Just add custom to the load path for now.
(nisp-add-to-load-path *nisp-custom-path*)
(setq custom-file (nisp-make-path "custom/my-custom.el"))

;;; Load this now before any requiring.
(load custom-file)

;;; Setup the rest of the load paths
(nisp-add-to-load-path nisp-load-path)
(nisp-add-to-load-path (nisp-make-path "my")) 

(require 'my-keymap)                    ; Set keys up now.

(nisp-add-to-load-path (nisp-make-path "3rd-party/jwiegley-magit"))
(nisp-add-to-load-path (nisp-make-path "3rd-party/rudel"))
(nisp-add-to-load-path (nisp-make-path "3rd-party/rudel/jupiter"))
(nisp-add-to-load-path (nisp-make-path "3rd-party/rudel/obby"))
(nisp-add-to-load-path (nisp-make-path "slime"))
(nisp-add-to-load-path (nisp-make-path "slime/contrib"))
(nisp-add-to-load-path (nisp-make-path "github-forks/gitsum"))

;;;; Requires
;;; Extra load toolsx
(require 'nisp-load-helper)
(require 'nisp-require-system-libraries)

;;; Include and turn on ido-mode
(require 'ido)
(ido-mode 1)

;;; Include magit. This is a special submodule
(require 'magit)

;;; basically some org mode hooks I wrote the other day right now
(require 'nisp-old)

;;;; Erc paste stuff, depends on stuff in nisp-old
(require 'nisp-paste)
(defalias 'paste-region 'nisp-paste-region)

;;;; Testing
(require 'inf-lisp)
(require 'slime)
(require 'inferior-slime)
(require 'slime-autodoc)

(slime-setup '(slime-repl 
               slime-asdf slime-parse
               slime-fancy))


;;; Gitsum
(require 'gitsum)

(require 'nisp-erc-cmd)