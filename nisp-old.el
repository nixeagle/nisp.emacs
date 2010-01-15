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


;;;; old erc stuff
;;; Defined commands
;; these are imported into erc and can be run with /OPME etc.
;; TODO: see if I can put my standard prefix in (nix:).
(defun erc-cmd-OPME ()
  "Request a chanop op to me in current channel."
  (erc-message "PRIVMSG"
               (format "chanserv op %s %s"
                       (erc-default-target)
                       (erc-current-nick)) nil))

(defun erc-cmd-DEOPME ()
  "Deop myself from current channel."
  (erc-cmd-DEOP (format "%s" (erc-current-nick))))


(defun erc-cmd-EEVAL (&rest expression)
  "evaluate given lisp expression."
  (let* ((expr (mapconcat 'identity expression " ")) ;(mapconcat 'identity expression " "))
         (result (condition-case err
                     (eval (read-from-whole-string expr))
                   (error (format "ERROR: %S" error)))))
    (erc-send-message (format "%s ---> %S" expr result))))
(defalias 'erc-cmd-E 'erc-cmd-EEVAL)
(defun erc-cmd-SEVAL (&rest expression)
  "evaluate given lisp expression."
  (let* ((expr (mapconcat 'identity expression " ")) ;(mapconcat 'identity expression " "))
         (result (condition-case err
                     (sawfish-eval-noread (read-from-whole-string expr))
                   (error (format "ERROR: %S" error)))))
    (erc-send-message (format "%s ---> %s" expr result))))


;;;; More legacy stuff to move over
;;; I'm at least renaming the functions now.
(defmacro nisp-erc-with-current-buffer (server target &rest body)
  "Execute forms in BODY in buffer for SERVER/TARGET.
See `nix-erc-get-buffer' for details on how SERVER and TARGET are handled."
  (declare (indent 1) (debug t))
  (let ((buf (gensym)))
    `(let ((,buf (nisp-erc-get-buffer ,target ,server)))
       (if (eq ,buf nil) nil
         (with-current-buffer ,buf
           ,@body)))))

(defun nisp-erc-send-message (channel message &optional server)
  "Send a MESSAGE to CHANNEL.
If SERVER is given send message to CHANNEL on that SERVER,
otherwise send message to the first CHANNEL on any server"
  (nisp-erc-with-current-buffer server channel
                                (erc-send-message message)))


(defun nisp-erc-get-buffer (target &optional server-name)
  "Get an ERC buffer on any server/channel.
Both arguments are strings or nil.

If TARGET only is passed, return first channel match or nil.

If TARGET and SERVER-NAME is passed, return buffer on server that  matches
or nil.

IF TARGET is nil and SERVER-NAME is passed, return related server buffer"
  (if (eq target nil)
      (process-contact
       (nisp-erc-get-server-proc server-name) :buffer)
    (erc-get-buffer target (nisp-erc-get-server-proc server-name))))

(defun nisp-erc-get-server-proc (&optional server-name)
  "Return server process matching SERVER-NAME or return nil on failure"
  (catch 'info
    (mapcar (lambda (proc)
              (let ((host (process-contact proc :host)))
                (cond
                 ((string-equal server-name host)
                  (throw 'info proc)))))
            (process-list))
    nil))				;no match return nil.

(require 'my-erc-pass)
(defun my-erc-connect-eighthbit ()
  "Connect me to eighthbit as nixeaglemacs"
  (interactive)
  (erc :server "platinum.eighthbit.net"
       :nick "nixeagle"
       :full-name "James"
       :port "6667"
       :password *my-erc-eighthbit-pass*))

(defun my-erc-connect-freenode ()
  "Connect to freenode using my nick"
  (interactive)
  (erc :server "irc.freenode.org"
       :nick "nixeagle"
       :full-name "James"
       :port "6667"
       :password *my-erc-freenode-pass*))

(defun my-erc-connect-oftc ()
  "Connect to freenode using my nick"
  (interactive)
  (erc :server "irc.oftc.net"
       :nick "nixeagle"
       :full-name "James"
       :port "6667"
       :password *my-erc-oftc-pass*))

(defalias 'my-erc-connect-debian 'my-erc-connect-oftc)

(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f %* %B%s%)\n"
          gnus-user-date-format-alist '((t . "%d.%m.%Y %H:%M"))
          gnus-sum-thread-tree-false-root ""
          gnus-sum-thread-tree-indent " "
          gnus-sum-thread-tree-root ""
          gnus-sum-thread-tree-leaf-with-other "├► "
          gnus-sum-thread-tree-single-leaf "╰► "
          gnus-sum-thread-tree-vertical "│")

(global-set-key (quote [select]) (quote move-end-of-line))

(provide 'nisp-old)