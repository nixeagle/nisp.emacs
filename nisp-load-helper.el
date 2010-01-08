;;;;;;; Nisp start file.
;;;;;;; Copyright (c) 2010 Nixeagle
;;;;;;; reuse is granted under GPLv3 or later

(defun nisp-reload-site-file ()
  "Reload `site-run-file'.

This has the effect of adding lisp libraries that were installed
by external means (apt, emerge, rpm, ...) to the
`load-path'. This means `load-library' finds the new library
without having to restart the current emacs session."
  (interactive)
  ;; This works on debian sid at least.
  (load "/etc/emacs/site-start.el"))

(when *nisp-use-toplevel-for-interactive-functions*
  (defalias 'reload-site-file 'nisp-reload-site-file))

;;; we provide this package
(provide 'nisp-load-helper)