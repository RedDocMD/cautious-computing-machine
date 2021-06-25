(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(use-package flycheck company lsp-ui rustic lsp-mode base16-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Set the theme (from base16)
(load-theme 'base16-gruvbox-dark-hard t)
;; Set font
(add-to-list 'default-frame-alist
	     '(font . "FiraCode Nerd Font-11"))

;; General LSP config
(use-package lsp-mode
	     :ensure
	     :commands lsp
	     
	     :custom
	     (lsp-rust-analyzer-cargo-watch-command "clippy")
	     (lsp-eldoc-rendera-all t)
	     (lsp-idle-delay 0.6)
	     (lsp-rust-analyzer-server-display-inlay-hints t)

	     :config
	     (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
	     :ensure
	     :commands lsp-ui-mode

	     :custom
	     (lsp-ui-peek-always-show t)
	     (lsp-ui-sideline-show-hover t)
	     (lsp-ui-doc-enable nil))

(use-package company
	     :ensure

	     :custom
	     (company-idle-delay 0.25)

	     :bind
	     (:map company-active-map
		   ("C-n" . company-select-next)
		   ("C-p" . company-select-previous)
		   ("M-<" . company-select-first)
		   ("M->" . company-select-last)))

	     
;; (use-package yasnippet
;;  :ensure
;;  :config
;;  (yas-reload-all)
;;  (add-hook 'prog-mode-hook 'yas-minor-mode)
;;  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package flycheck :ensure)

;; Rust config (to be specific, rustic config)
(use-package rustic
	     :ensure
	     :bind (:map rustic-mode-map
			 ("M-j" . lsp-ui-imenu)
			 ("M-?" . lsp-find-references)
			 ("C-c C-c l" . flycheck-list-errors)
			 ("C-c C-c a" . lsp-execute-code-action)
			 ("C-c C-c r" . lsp-rename)
			 ("C-c C-c q" . lsp-workspace-restart)
			 ("C-c C-c Q" . lsp-workspace-shutdown)
			 ("C-c C-c s" . lsp-rust-analyzer-status))
	     :config
	     (setq rustic-format-on-save t)
             (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))


(defun rk/rustic-mode-hook ()
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

(setq lsp-rust-analyzer-server-display-inlay-hints t)
