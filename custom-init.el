;;; Custom emacs settings

;; Set default size in windows system
(if window-system
    (progn
      (add-to-list 'initial-frame-alist '(height . 45))
      (add-to-list 'initial-frame-alist '(width . 130))))

;; Do not show welcome message
(setq inhibit-startup-message t)

;; Abbreviating minor mode indicators
(require 'diminish)

;; line number
(global-linum-mode t)

;; open .h in C++ mode by default
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;; Force gdb-mi to not dedicate any windows
(defadvice gdb-display-buffer (after undedicate-gdb-display-buffer)
  (set-window-dedicated-p ad-return-value nil))
(ad-activate 'gdb-display-buffer)

(defadvice gdb-set-window-buffer (after undedicate-gdb-set-window-buffer (name &optional ignore-dedi window))
  (set-window-dedicated-p window nil))
(ad-activate 'gdb-set-window-buffer)

;; GDB key bindings
(require 'gud)
(global-set-key [f4]    'gud-break)
(global-set-key [(shift f4)]    'gud-remove)
(global-set-key [f5]    'gud-cont)
(global-set-key [(shift f5)]    'gud-finish)
(global-set-key [f11]   'gud-next)
(global-set-key [f12]   'gud-step)

;; Set TABs
;; (setq tab-width 2)
;; (setq tab-stop-list (number-sequence 2 200 2))
;; (setq-default indent-tabs-mode nil)

;; toggle-window-split
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-x |") 'toggle-window-split)

;; == yasnippet ==
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; == undo-tree ==
(use-package undo-tree
  :init (global-undo-tree-mode t)
  :ensure t
  :defer t
  :diminish ""
  :config
  (progn
    (define-key undo-tree-map (kbd "C-x u") 'undo-tree-visualize)
    (define-key undo-tree-map (kbd "C-/") 'undo-tree-undo)
    (define-key undo-tree-map (kbd "M-/") 'undo-tree-redo)))

;; == workgroups2 ==
;; (use-package workgroups2
;;   :ensure t
;;   :config
;;   (workgroups-mode 1))

;; == smartparens ==
(use-package smartparens
  :ensure t
  :defer t
  :diminish ""
  :init
  (progn
    (show-smartparens-global-mode +1))
  :config
  (progn
    (use-package smartparens-config)
    (setq sp-base-key-bindings 'paredit)
    (setq sp-autoskip-closing-pair 'always)
    (setq sp-hybrid-kill-entire-symbol nil)
    (sp-use-paredit-bindings)))

;; Windmove setting
(if (display-graphic-p)
    (windmove-default-keybindings 'meta)
  (progn
    (global-set-key (kbd "ESC <left>")  'windmove-left)
    (global-set-key (kbd "ESC <right>") 'windmove-right)
    (global-set-key (kbd "ESC <up>")    'windmove-up)
    (global-set-key (kbd "ESC <down>")  'windmove-down)))

;; Enable mouse tracking for terminal
(if (display-graphic-p)
    nil
  (progn
    (require 'mouse)
    (xterm-mouse-mode t)
    (defun track-mouse (e))))

;; ;; == ggtags
;; (defun my/setup-ggtags ()
;;   (interactive)
;;   (ggtags-mode 1)
;;   ;; turn on eldoc with ggtags
;;   ;; (setq-local eldoc-documentation-function #'ggtags-eldoc-function)

;;   (define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
;;   (define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
;;   (define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
;;   (define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
;;   (define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
;;   (define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
;;   (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark))

;; (use-package ggtags
;;   :ensure t
;;   :defer t
;;   :init
;;   (progn
;;     (add-hook 'c-mode-common-hook
;; 	      (lambda ()
;; 		(when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
;; 		  (my/setup-ggtags))))))

;; == irony-mode ==
;; (use-package irony
  ;; :ensure t
  ;; :defer t
  ;; :init
  ;; (add-hook 'c++-mode-hook 'irony-mode)
  ;; (add-hook 'c-mode-hook 'irony-mode)
  ;; (add-hook 'objc-mode-hook 'irony-mode)
  ;; :config
  ;; ;; replace the 'completion-at-point' and 'complete-symbol' bindings in
  ;; ;; irony-mode's buffers by irony-mode's function
  ;; (defun my-irony-mode-hook ()
  ;;   (define-key irony-mode-map [remap completion-at-point]
  ;;     'irony-completion-at-point-async)
  ;;   (define-key irony-mode-map [remap complete-symbol]
  ;;     'irony-completion-at-point-async))
  ;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  ;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
