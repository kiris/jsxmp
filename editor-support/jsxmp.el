;;; jsxmp.el --- annotate the JavaScript

;; Copyright (C) 2011, 2012  Yoshiaki Iwanaga

;; Author: Yoshiaki Iwanaga <kiris60@gmail.com>
;; Version: 0.0.1

;;; Commentary:

;;

;;; Code:

(require 'cl)

(defconst jsxmp:version "0.0.1")

(defvar jsxmp:command-name "jsxmp" "The xmpfilter command name.")

;; (defadvice jsxmp:comment-dwim (around rct-hack activate)
;;   "If comment-dwim is successively called, add => mark."
;;   (if (and (eq major-mode 'ruby-mode)
;;            (eq last-command 'jsxmp:comment-dwim)
;;            ;; TODO =>check
;;            )
;;       (insert "=>")
;;     ad-do-it))

(defun jsxmp:current-line ()
  "Return the vertical position of point..."
  (+ (count-lines (point-min) (point))
     (if (= (current-column) 0) 1 0)))

(defun jsxmp:save-position (proc)
  "Evaluate proc with saving current-line/current-column/window-start."
  (let ((line (jsxmp:current-line))
        (col  (current-column))
        (wstart (window-start)))
    (funcall proc)
    (goto-char (point-min))
    (forward-line (1- line))
    (move-to-column col)
    (set-window-start (selected-window) wstart)))

;; (defun jsxmp (&optional option)
;;   "Run jsxmp for annotation/test/spec on whole buffer."
;;   (interactive)
;;   (jsxmp:save-position
;;    (lambda ()
;;      (rct-shell-command (funcall xmpfilter-command-function option)))))

(defun jsxmp:run-command (command &optional buffer)
  "Replacement for `(shell-command-on-region (point-min) (point-max) command buffer t' because of encoding problem."
  (let ((input-file (concat (make-temp-name "jsxmp-in") ".js"))
        (output-file (concat (make-temp-name "jsxmp-out") ".js"))
        (coding-system-for-read buffer-file-coding-system))
    (write-region (point-min) (point-max) input-file nil 'nodisp)
    (shell-command (format "%s %s > %s" command input-file output-file))
    (with-current-buffer (or buffer (current-buffer))
      (insert-file-contents output-file nil nil nil t))
    (delete-file input-file)
    (delete-file output-file)))

(provide 'jsxmp)
;;; direx.el ends here
