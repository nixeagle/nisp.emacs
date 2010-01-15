;;; nisp-erc.el ---
;;
;; Filename: nisp-erc.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Fri Jan 15 04:53:32 2010 (+0000)
;; Version: 0.1
;; Last-Updated:
;;           By:
;;     Update #: 4
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

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
                (and (stringp host)
                     (string= server-name host)
                     (throw 'info proc))))
            (process-list))
    nil))				;no match return nil.

(provide 'nisp-erc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nisp-erc.el ends here
