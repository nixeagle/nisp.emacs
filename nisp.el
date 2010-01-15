;;;;;; nisp
;;;; Copyright (c) 2010 Nixeagle
;;;; Released under GNU GPLv3 or later


;;; These really need moved to something org-mode specific.
(defun nisp-last-buffer ()
  "Get the buffer point was in."
  (second (buffer-list)))

(defun nisp-last-buffer-with-file ()
  "Get the last visited buffer that has an associated filename."
  (dolist (buf (buffer-list))
    (when (stringp (buffer-file-name buf))
      (return buf))))

;; (nisp:directory-changelog-from-file "/home/james/lisp/test.org")
;; "/home/james/lisp/changelog.org"
(defun nisp:directory-changelog-from-file (filepath)
  "Return a string with the changelog associated with FILEPATH.

Given: \"/home/james/lisp/test.org\"
Return: \"/home/james/lisp/changelog.org\""
  (concat (file-name-directory filepath) "changelog.org"))

;;  what I'm trying to do is make M-x org-remember RET l automatically
;;  put an entry in the correct changelog. The only way to do that is to
;;  look up the last buffer that was editing a file and look for a
;;  changelog in the current directory.
(defun nisp:org-log-hook ()
  "When called by remember-org-templa"
  (nisp:directory-changelog-from-file
   (buffer-file-name (nisp:last-buffer-with-file))))

(provide 'nisp)