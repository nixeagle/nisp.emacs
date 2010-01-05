(defun my-recursive-file-regexp (directory regexp)
  "List of files matching REGEXP"
  (let ((results ()))
    (dolist (path (directory-files directory t))
      (let ((file (file-name-nondirectory path)))
        (cond
         ((string= file ".") t)
         ((string= file "..") t)
         ((file-directory-p path) ; keep going
          (setq results 
                (append (my-recursive-file-regexp path regexp)
                        results)))
         ((string-match regexp path)
          (add-to-list 'results path)))))
    results))

(defun my-unique-list (list)
  "Return only unique elements in LIST."
  (let ((results ()))
    (dolist (item list)
      (add-to-list 'results item))
    results))

(defun my-list-directories-with-file (root-dir regexp)
  "List all directories a file matching REGEXP was found.
  
  Start recursion with `my-recursive-file-regexp' at ROOT-DIR"
  (my-unique-list
     (mapcar 'file-name-directory
             (my-recursive-file-regexp root-dir regexp))))

(defun my-add-subdirs-to-load-list (parent-dir regexp)
  "Given PARENT-DIR add subdirs with .el files to `load-list'."
  (mapcar (lambda (arg)
            (add-to-list 'load-path arg))
          (my-list-directories-with-file parent-dir regexp)))

(provide 'nisp-old)