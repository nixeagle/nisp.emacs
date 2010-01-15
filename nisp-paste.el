;;;;;; nisp-paste
;;;; Copyright (c) 2010 Nixeagle
;;;; Released under GNU GPLv3 or later
;;; version: 0.1.2
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
(defcustom nisp-paste-remote-host ""
  "Host to paste to.

This needs to be a filepath that tramp can use to do the
connection. This means you can specify any combination that tramp
can do as well as specify that pastes go to your local machine."
  :type '(string)
  :group 'nisp-paste)
(defcustom nisp-paste-link-prefix "http://localhost/"
  "Link to display for others to click on."
  :type '(string)
  :group 'nisp-paste)

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
  (let ((html-buffer (htmlize-region beg end))
        (file (concat nisp-paste-remote-host name)))
    (progn
      (nisp-write-buffer-to-file html-buffer file)
      (let ((url (concat nisp-paste-link-prefix name)))
        (nisp-erc-send-message
         (buffer-name (car (erc-buffer-list nil)))
         (concat "See " url " - " msg))))))


(provide 'nisp-paste)