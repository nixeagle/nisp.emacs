

;;; Please note that none of these commands are aliased like the rest of
;;; nisp uusually is. The reason for this is because erc expects
;;; commands to start with erc-cmd-
(defun nisp-erc-op-commands ()
  "Commands relating to channel management."
  (defun erc-cmd-OPME ()
    "Request a chanserv op to me in current channel."
    (erc-message "PRIVMSG"
                 (format "chanserv op %s %s"
                         (erc-default-target)
                         (erc-current-nick)) nil)))

(defun erc-cmd-L (ex)
  "Eval EX in Lisp; insert any output and the result at point."
  (my-slime-async-eval ex nil
                     (lambda (in out value)
                       (erc-send-message
                        (format "%s --> %s" in value)))))
(put 'erc-cmd-L 'do-not-parse-args t)

(provide 'nisp-erc-cmd)