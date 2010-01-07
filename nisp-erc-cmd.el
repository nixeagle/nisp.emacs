

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


(provide 'nisp-erc-cmd)