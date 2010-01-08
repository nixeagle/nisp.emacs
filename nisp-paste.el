;;;;;; nisp-paste
;;;; Copyright (c) 2010 Nixeagle
;;;; Released under GNU GPLv3 or later

;;;; TODO: Don't depend on legacy stuff!
(require 'nisp-old)

(defgroup nisp-paste nil
  "Paste to remote directory vie `tramp'."
  :group 'nisp)
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