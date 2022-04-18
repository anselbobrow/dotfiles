;; load emacs 24's package system. Add MELPA repository.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(focus-follows-mouse nil)
 '(fringe-mode (quote (1 . 1)) nil (fringe))
 '(inhibit-startup-screen t)
 '(initial-buffer-choice (quote recentf-open-files))
 '(overflow-newline-into-fringe nil)
 '(package-selected-packages
   (quote
    (yasnippet-classic-snippets helm org-link-minor-mode rainbow-delimiters yasnippet paredit racket-mode)))
 '(scroll-bar-mode nil)
 '(standard-indent 2)
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(window-divider-default-bottom-width 1)
 '(window-divider-default-places (quote right-only))
 '(window-divider-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#242424" :foreground "#f6f3e8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "nil" :family "Monaco"))))
 '(racket-selfeval-face ((t (:foreground "LightSkyBlue2"))))
 '(window-divider ((t (:foreground "gray36"))))
 '(window-divider-first-pixel ((t (:foreground "gray36")))))

(put 'narrow-to-region 'disabled nil)

(load-theme 'wombat t)

(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'fundamental-mode-hook 'visual-line-mode)
(add-hook 'racket-mode-hook 'paredit-mode)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(set-frame-parameter nil 'fullscreen 'fullboth)

(eval-after-load 'racket-mode
  '(define-key racket-mode-map (kbd "C-c c") 'racket-check-syntax-mode))

(setq racket-racket-program "/Applications/Racket/bin/racket")
(setq racket-raco-program "/Applications/Racket/bin/raco")

(add-to-list 'load-path "~/.emacs.d/popup-el-master")

(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
