

(setq-mode-local c++-mode
                 semanticdb-find-default-throttle
                 '(project unloaded system recursive))

(semantic-reset-system-include 'c++-mode)


(setq-mode-local c-mode
                 semanticdb-find-default-throttle
                 '(project unloaded system recursive))

(semantic-reset-system-include 'c-mode)

(require 'cl)
(require 'eieio)
(require 'cedet)
(require 'ecb)

;; Semantic
(require 'cedet)
;(semantic-load-enable-excessive-code-helpers)
(setq senator-minor-mode-name "SN")

;(global-semantic-mru-bookmark-mode 1)
;(require 'semantic-decorate-include)
(require 'semantic-ia)

(semantic-load-enable-minimum-features)

;; ctags
(require 'semanticdb)

(require 'xcscope)


(require 'speedbar)

;(require 'semantic-gcc)

(provide 'nisp-require-system-libraries)