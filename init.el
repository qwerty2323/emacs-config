; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
                         ;("marmalade" . "http://marmalade-repo.org/packages/")))
(add-to-list 'load-path "~/.emacs.d/vendor")
; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; list the packages you want
(setq package-list '(better-defaults
                     solarized-theme
                     helm
                     helm-projectile
                     helm-ag
                     ruby-electric
                     seeing-is-believing
                     chruby
                     inf-ruby
                     rubocop
                     yasnippet
                     robe
                     auto-complete))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'better-defaults)

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'ruby-mode)

(load-theme 'solarized-dark t)

;; Show line numbers
(global-linum-mode)

;; Typography
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 150
                    :weight 'normal
                    :width 'normal)

(require 'helm)
(require 'helm-projectile)
(require 'helm-ag)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "s-f") #'helm-projectile-ag)
(global-set-key (kbd "s-t") #'helm-projectile-find-file-dwim)
(global-set-key (kbd "<f2>") 'rubocop-mode)    ; F2
;; Autoclose paired syntax elements like parens, quotes, etc
(require 'ruby-electric)
(add-hook 'ruby-mode-hook 'ruby-electric-mode)

(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)

(require 'robe)
(require 'rubocop)
(require 'auto-complete)
(add-hook 'inf-ruby-minor-mode 'rubocop-mode)
(add-hook 'rubocop-mode-hook 'flycheck-mode)
(add-hook 'rubocop-mode-hook 'robe-mode)
(add-hook 'rubocop-mode-hook 'auto-complete-mode)
(add-hook 'rubocop-mode-hook 'ruby-refactor-mode)
(add-hook 'robe-mode-hook 'ac-robe-setup)

(autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)

(add-hook 'compilation-finish-functions
          (lambda (buf strg)
            (switch-to-buffer-other-window "*compilation*")
            (read-only-mode)
            (goto-char (point-max))
            (local-set-key (kbd "q")
                           (lambda () (interactive) (quit-restore-window)))))

(add-hook 'before-save-hook 'whitespace-cleanup)
