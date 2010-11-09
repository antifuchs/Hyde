;;; hyde.el
;; Copyright (C) 2004 Noufal Ibrahim <noufal at nibrahim.net.in>
;;
;; This program is not part of Gnu Emacs
;;
;; hyde.el is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;; Constants for internal use
(defconst hyde/hyde-version "0.1" 
  "Hyde version")

;; Internal customisable variables
(defvar hyde-mode-hook nil
  "Hook called by \"hyde-mode\"")

(defcustom hyde-home
  "/home/noufal/blog"
  "Root directory where your entire blog resides")

(defcustom hyde-deploy-dir
  "_site"
  "Directory which needs to be deployed")

(defcustom hyde-posts-dir 
  "_posts"
  "Directory which contains the list of posts")

(defcustom hyde/hyde-list-posts-command 
  "/bin/ls -1tr "
  "Command to list the posts")

;; Faces and font-locking
(defface hyde-header-face
  '(
    (((type tty) (class color)) (:foreground "blue" ))
    (((type graphic) (class color)) (:foreground "blue" ))
    (t (:foreground "blue" ))
    )
  "Face for a hyde header")

(defvar hyde-header-face 'hyde-header-face "Face for a hyde header")

(defconst hyde-font-lock-keywords
  (list
   '("^::.*" . hyde-header-face)
   )
  "Font lock keywords for Hyde mode")

;; Utility functions
(defun hyde/load-posts ()
  "Load up the posts and present them to the user"
  ;; Insert headers
  (insert ":: Editing blog at:" hyde-home "\n")
  ;; Insert posts
  (save-excursion
    (let (
	  (posts (split-string (shell-command-to-string
				(concat "cd " hyde-home "/" hyde-posts-dir " ; " hyde/hyde-list-posts-command )) "\n")))
      (dolist (post posts)
	(insert (concat post "\n"))))
    ;; Insert footer
    (insert (concat ":: Hyde version " hyde/hyde-version "\n"))))

;; (defun hyde/open-post-maybe (pos)
  
  

;; Keymaps
(defvar hyde-mode-map
  (let 
      ((hyde-mode-map (make-sparse-keymap)))
    (define-key hyde-mode-map (kbd "n") 'next-line)
    (define-key hyde-mode-map (kbd "p") 'previous-line)
    (define-key hyde-mode-map (kbd "C-j") 'hyde/open-post-maybe)
    hyde-mode-map)
  "Keymap for Hyde")



(defun hyde/hyde-mode ()
  "The Hyde major mode to edit Jekyll posts. I love how that sounds :)"
  (kill-all-local-variables)
  (use-local-map hyde-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(hyde-font-lock-keywords))
  (setq major-mode 'hyde/hyde-mode
	  mode-name "Hyde")
  (run-hooks hyde-mode-hook))


;; Entry point
(defun hyde ()
  "Enters hyde mode"
  (interactive)
  (switch-to-buffer (get-buffer-create "*Hyde*"))
  (hyde/hyde-mode)
  (hyde/load-posts)
  (toggle-read-only 1))
  
(provide 'hyde)


(local-set-key "n" 'self-insert-command)
