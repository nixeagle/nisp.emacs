;;; nisp-org-jekyll -- summary
;;; Copyright (c) 2010 Nixeagle
;;; Released under GNU GPLv3 or later
;;; Commentary:
;; The function nisp-jekyll-make-index and
;; ....
;; came from git://github.com/eschulte/babel-dev.git
;; in the file publish.org on [2010-01-09 Sat]
;;; Code:

(require 'nsip-assert)

(defvar nisp-org-jekyll-unit-tests nil
  "T means test assertions run.")
(defun nisp-org-jekyll-toggle-tests ()
  "Toggle unittests for `nisp-org-jekyll'."
  (interactive)
  (setq nisp-org-jekyll-unit-tests
        (not nisp-org-jekyll-unit-tests)))

(defgroup nisp-org-jekyll nil
  "Interaction with the jekyll website thing."
  :group 'nisp)

(defcustom nisp-org-jekyll-default-front-matter '(("layout" . "default"))
  "Alist containing default Jekyll yaml frontmatter.

Jekyll expects each page to have frontmatter put at the start.

Please reference http://wiki.github.com/mojombo/jekyll/yaml-front-matter"
  :type '(alist)                        ; Fix up customize alist type here.
  :group 'nisp-org-jekyll)

(defconst nisp-org-jekyll-front-matter-start "---\n"
  "Top of the YAML header.")

(defconst nisp-org-jekyll-front-matter-end "\n---\n\n"
  "Bottom or end of the YAML header.")

(defun nisp-add-extension (filename extension)
  "Add EXTENSION to the end of FILENAME if its not there yet.

FILENAME and EXTENSION both need to be a string.  EXTENSION must
not start with a leading dot."
  (if (string= (file-name-extension filename) extension)
      filename
    (concat filename "." extension)))

(when nisp-org-jekyll-unit-tests
   (nisp-assert-many-string= (prin1-to-string (random 100))
    (nisp-add-extension "foo" "org")
    (nisp-add-extension "foo.org" "org")
    (nisp-add-extension "foo.org" "orga")))

(defun nisp-org-add-org-extension (filename)
  "Add `org-mode' extension to FILENAME if it is not there yet.

FILENAME should be a string."
  (nisp-add-extension filename "org"))

(defun nisp-org-jekyll-format-yaml-pair (yaml-pair)
  "Convert YAML-PAIR to yaml line.

YAML-PAIR needs to be a dotted pair, eg:
  '(car . cdr)"
  (format "%s: %s" (car yaml-pair) (cdr yaml-pair)))

(defun nisp-org-jekyll-format-yaml (yaml)
  "Convert YAML to yaml.

YAML should be a list of dotted pairs that can be processed by
`nisp-org-jekyll-format-yaml-pair'."
  (mapconcat #'nisp-org-jekyll-format-yaml-pair
          yaml "\n"))

(defun nisp-org-jekyll-format-frontmatter (dotted-pairs)
  "Convert DOTTED-PAIRS to jekyll frontmatter."
  (concat nisp-org-jekyll-front-matter-start
          (nisp-org-jekyll-format-yaml dotted-pairs)
          nisp-org-jekyll-front-matter-end))

(defun nisp-file-name-buffer-directory (filename &optional extension buffer)
  "Expand FILENAME adding EXTENSION using BUFFER's directory.

If EXTENSION is nil, no extension is appended."
  (expand-file-name
   (or (and extension (nisp-add-extension filename extension))
       filename)
   (file-name-directory
    (buffer-file-name (or buffer (current-buffer))))))

;;; From http://github.com/eschulte/babel-dev/blob/master/publish.org
;;; (intially) written by Eric Schulte
(defun nisp-org-jekyll-make-index ()
  (mapc
   (lambda (file)
     (let ((full-file (expand-file-name
                       (nisp-org-add-org-extension file)
                       (file-name-directory (buffer-file-name))))
           (yaml-front-matter `(("layout" . "default")
                                ("title" . ,file)))
           html)
       ;; go to the top level tasks heading
       (find-file full-file)
       (setq html (org-export-as-html nil nil nil 'string t nil))
       (with-temp-file (concat file ".html")
         (when yaml-front-matter
           (insert nisp-org-jekyll-front-matter-start)
           (mapc (lambda (pair) (insert (format "%s: %s\n" (car pair) (cdr pair))))
                 yaml-front-matter)
           (insert nisp-org-jekyll-front-matter-end))
         (insert html)))) '("index" "publish")))

;;; This is also from:
;;; http://github.com/eschulte/babel-dev/blob/master/publish.org
;;; (intially) written by Eric Schulte
;;; Its not the most understandable, I will need to split this one up.
(defun nisp-org-jekyll-blog-posts ()
  (save-excursion
    ;; map over all tasks entries
    (let ((dev-file (expand-file-name
                     "development.org"
                     (file-name-directory (buffer-file-name))))
          (posts-dir (expand-file-name
                      "_posts"
                      (file-name-directory (buffer-file-name))))
          (yaml-front-matter '(("layout" . "default"))))
      ;; go through both the tasks and bugs
      (mapc
       (lambda (top-level)
         (find-file dev-file)
         (goto-char (point-min))
         (org-shifttab)
         (outline-next-visible-heading top-level)
         (org-show-subtree)
         (org-map-tree
          (lambda ()
            (let* ((props (org-entry-properties))
                   (todo (cdr (assoc "TODO" props)))
                   (time (cdr (assoc "TIMESTAMP_IA" props))))
              ;; each task with a state and timestamp can be exported as a
              ;; jekyll blog post
              (when (and todo time)
                (message "time=%s" time)
                (let* ((heading (org-get-heading))
                       (title (replace-regexp-in-string
                               "[:=\(\)\?]" ""
                               (replace-regexp-in-string
                                "[ \t]" "-" heading)))
                       (str-time (and (string-match "\\([[:digit:]\-]+\\) " time)
                                      (match-string 1 time)))
                       (to-file (format "%s-%s.html" str-time title))
                       (org-buffer (current-buffer))
                       (yaml-front-matter (cons (cons "title" heading) yaml-front-matter))
                       html)
                  (org-narrow-to-subtree)
                  (let ((level (- (org-outline-level) 1))
                        (contents (buffer-substring (point-min) (point-max))))
                    (dotimes (n level nil) (org-promote-subtree))
                    (setq html (org-export-as-html nil nil nil 'string t nil))
                    (set-buffer org-buffer)
                    (delete-region (point-min) (point-max))
                    (insert contents)
                    (save-buffer))
                  (widen)
                  (with-temp-file (expand-file-name to-file posts-dir)
                    (when yaml-front-matter
                      (insert "---\n")
                      (mapc (lambda (pair) (insert (format "%s: %s\n" (car pair) (cdr pair))))
                            yaml-front-matter)
                      (insert "---\n\n"))
                    (insert html))
                  (get-buffer org-buffer)))))))
       '(1 2)))))

(provide 'nisp-org-jekyll)
;;; nisp-org-jekyll.el ends here