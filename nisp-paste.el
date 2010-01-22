;;;;;; nisp-paste
;;;; Copyright (c) 2010 Nixeagle
;;;; Released under GNU GPLv3 or later
;;; version: 0.6.4
;;;
;;; Dependency on htmlize is included with the repo:
;;; (add-to-list 'load-path "/path/to/nisp.emacs") ; for this file
;;; (add-to-list 'load-path "/path/to/nisp.emacs/3rd-party") ; for htmlize
;;; (require 'nisp-paste) ; for this lib
;;;
;;; If you want paste-region, you need to do:
;;; (defalias 'paste-region 'nisp-paste-region) in your .emacs
;;; Bind to your global map with:
;;; (global-set-key [(hyper ?p)] 'nisp-paste-region)
;;; or some such.


;;;; TODO: Don't depend on legacy stuff!
(require 'tramp)
(require 'htmlize)
(require 'nisp-erc)

(defgroup nisp-paste nil
  "Paste to remote directory vie `tramp'."
  :group 'programming)
(defcustom nisp-paste-remote-directory
  (or (and (boundp 'nisp-paste-remote-host)
           nisp-paste-remote-host)
      "/vps:paste/")
  "Host to paste to.

This needs to be a filepath that tramp can use to do the
connection.  This means you can specify any combination that tramp
can do as well as specify that pastes go to your local machine.

This needs to be of a form you would pass to `tramp'.
Something like this works for me:
  /vps:paste/"
  :type 'directory
  :package-version '(nisp-paste . 0.6.1)
  :group 'nisp-paste)

(defcustom nisp-paste-link-prefix "http://localhost/"
  "Link to display for others to click on."
  :type '(string)
  :package-version '(nisp-paste . 0.1.0)
  :group 'nisp-paste)

(defcustom nisp-paste-format-filename-functions '(nisp-paste-replace-spaces)
  "Hooks called before saving a file to disk.

These get called passing one argument, the filename to apply
changes to.  All functions in this list are run using the returned
filename from prior calls."
  :type '(hook)
  :package-version '(nisp-paste . 0.5.0)
  :options '(nisp-paste-append-filename-extension
             nisp-paste-replace-spaces)
  :group 'nisp-paste)

(defcustom nisp-paste-url-space-char "-"
  "Spaces in paste filenames are replaced with this character.

This should be a `string' with `length' 1."
  ;;This is not enforced correctly, will need to wait until nisp-types
  ;;is started. I already have the correct type defined in old code not
  ;;in this repository.
  :type '(string)
  :package-version '(nisp-paste . 0.3.0)
  :group 'nisp-paste)

(defcustom nisp-paste-filename-extension ".html"
  "Extension for pastes.

By default no extension is added automatically. This is for
purely aesthetic reasons and is not too useful if your server
sends plain/text mime headers.

If this is the case, change this to .html or modify your .htacess
for the domain to send text/html by default."
  :type '(string)
  :package-version '(nisp-paste . 0.6.0)
  :group 'nisp-paste)

(defun nisp-paste-append-filename-extension (filename &optional extension)
  "Append EXTENSION or if nil `nisp-paste-filename-extension' to FILENAME."
  (concat filename (or extension nisp-paste-filename-extension)))

(defun nisp-paste-replace-spaces (filename &optional replace)
  (replace-regexp-in-string " "
  (or replace nisp-paste-url-space-char) filename))

(defun nisp-paste-format-filename (filename &optional functions)
  "Formats FILENAME by running FUNCTIONS over it.

FUNCTIONS defaults to `nisp-paste-format-filename-functions'."
  (dolist (func (or functions nisp-paste-format-filename-functions) filename)
    (setq filename (funcall func filename))))

(defun nisp-write-buffer-to-file (buffer file)
  "Write BUFFER to FILE."
  ;; Works with remote hosts through TRAMP.
  (save-excursion
    (with-current-buffer buffer
      (write-region (point-min)
                    (point-max)
                    file)))
  ;; Why do we return true all the time?
  t)

(defun nisp-paste-region (beg end name msg)
  "Paste region"
  (interactive "r\nsPaste Name:\nsMessage:")
  (let* ((html-buffer (htmlize-region beg end))
         (paste-name (nisp-paste-format-filename name))
         (file (concat nisp-paste-remote-directory paste-name)))
    (progn
      (nisp-write-buffer-to-file html-buffer file)
      (let ((url (concat nisp-paste-link-prefix paste-name)))
        (nisp-erc-send-message
         (buffer-name (car (erc-buffer-list nil)))
         (concat "See " url (or msg " - " msg)))))))


(provide 'nisp-paste)