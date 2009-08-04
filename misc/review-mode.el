;;; review-mode.el
;;; Major mode for ReVIEW
;;; 
;;; NOTE: experimental.
;;;
;;; setup
;;;   (require 'review-mode)
;;;   (add-to-list 'auto-mode-alist '("\\.re$" . review-mode))
;;;
;;; uses
;;; C-c\c review-code-tag => @<code>{}
;;; C-crc review-code-tag-region => @<code>{hogehoge}

(require 'derived)

(defvar review-mode-hook nil
  "Hooks run when entering `review-mode' major mode")

(define-derived-mode review-mode text-mode "ReVIEW"
  "Major mode for ReVIEW editing.
\\{review-mode-map}"
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate "=+\\|\\++\\|[ \t\n\^L]*$")
  (make-local-variable 'paragraph-start)
  (setq paragraph-start "=+\\|\\++\\|[ \t\n\^L]")
  (make-local-variable 'require-final-newline)  
  (setq require-final-newline t)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((review-font-lock-keywords) t nil))
  (make-local-variable 'font-lock-keywords)
  (setq font-lock-keywords review-font-lock-keywords)
  (make-local-variable 'outline-regexp)
  (setq outline-regexp "^\\(=+\\)")
  (outline-minor-mode t)
  (review-setup-keys)
  (setq indent-tabs-mode nil)
  (run-hooks 'review-mode-hook)
)

(defvar review-heading1-face 'font-lock-keyword-face)
(defvar review-heading2-face 'font-lock-type-face)
(defvar review-heading3-face 'font-lock-variable-name-face)
(defvar review-heading4-face 'font-lock-comment-face)
(defvar review-variable-face 'font-lock-function-name-face)
(defvar review-footnote-face 'font-lock-function-name-face)
(defvar review-block-face 'font-lock-function-name-face)

(defvar review-font-lock-keywords
  (list
   '("^= .*$"
     0 review-heading1-face)
   '("^== .*$"
     0 review-heading2-face)
   '("^=== .*$"
     0 review-heading3-face)
   '("^=====* .*$"
     0 review-heading4-face)
   '("@<[^>]+>{[^}]*}"         ; @<..>{...}
     0 review-variable-face)
   '("^//[a-z]+[^{\n]+$"       ; //...[..][..]
     0 review-footnote-face)
   '("^//.+{"                  ; //...[..][..]{
     0 review-block-face)
   '("^//}"                    ; //}
     0 review-block-face)
   ))

(defun review-code-tag ()
  (interactive)
  (goto-char (point))
  (insert "@<code>{}")
  (goto-char (- (point) 1))
)

(defun review-code-tag-region (beg end)
  (interactive "r")
  (goto-char end)
  (insert "}")
  (goto-char beg)
  (insert "@<code>{")
  (goto-char beg)
)

(defun review-setup-keys ()
  (interactive)
  (define-key review-mode-map "\C-c\c" 'review-code-tag)
  (define-key review-mode-map "\C-crc" 'review-code-tag-region)
)

(provide 'review-mode)
;;; review-mode.el ends here

