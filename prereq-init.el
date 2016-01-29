;;; Prerequisite emacs settings
;; start package.el with emacs
(require 'package)
(setq package-enable-at-startup nil)

;; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; initialize package.el
(package-initialize)

;; make sure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; bind-key
(require 'bind-key)

;; powerline
(use-package powerline
  :ensure t)

;; Load theme
(use-package moe-theme
  :ensure t
  :config
  (progn
    (moe-dark)
    (powerline-moe-theme)
    (show-paren-mode t)
    (setq show-paren-mode 'expression)))

;; start IDO
(require 'ido)
(ido-mode t)

;; bind ibuffer key combo
(bind-key "C-x C-b" 'ibuffer)

;; == company-mode ==
(use-package company
  :ensure t
  :defer t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (progn
    ;; (use-package company-irony
    ;;   :ensure t
    ;;   :config
    ;; (add-to-list 'company-backends 'company-irony))

    (use-package company-c-headers
      :ensure t
      :config
      (add-to-list 'company-backends 'company-c-headers))
    (setq company-idle-delay .5
          company-minimum-prefix-length 1
          company-show-numbers t
          company-selection-wrap-around nil
          company-tooltip-limit 10
          company-dabbrev-downcase nil
          company-transformers ' (company-sort-by-occurrence)
          company-begin-commands '(self-insert-command))
    (bind-keys :map company-active-map
               ("<tab>" . company-complete)))
  :bind ("C-;" . company-complete-common))

;; == flycheck ==
(use-package flycheck
  :ensure t
  :defer t
  :bind (("M-g M-n" . flycheck-next-error)
         ("M-g M-p" . flycheck-previous-error)
         ("M-g M-=" . flycheck-list-errors))
  :init (global-flycheck-mode)
  :config
  (progn
    ;; (use-package flycheck-irony
    ;;   :ensure t
    ;;   :init '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
    (setq flycheck-display-errors-delay .3)))
