;; -*- lexical-binding: t -*-

;;{{{ General Stuff

(set-face-attribute 'default nil :height 160)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)

;(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar
;; (beacon-mode 1)

;; Start emacs server
(server-start)

(setq backup-directory-alist

      `((".*" . ,"~/.emacs.d/emacs-backup")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d/emacs-backup" t)))

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; Enforces sizeof compilation windows
(require 'shackle)
(setq shackle-rules '((compilation-mode :noselect t :align 'below :size 25))
      shackle-default-rule '(:select t))
(require 'persp-projectile)
(define-key projectile-mode-map (kbd "s-s") 'projectile-persp-switch-project)

(setq tab-width 4)
(setq c-basic-offset 'tab-width)  ; Set the C/C++/Java.. mode to use this tab width

;; Set up the visible bell
(setq visible-bell nil)
(setq-default indent-tabs-mode nil)
(load-theme 'doom-monokai-classic t)

; Required to avoid weird crashes
(setq native-comp-enable-subr-trampolines nil)

;;{{{ PATH manipulation
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
              "[ \t\n]*$" "" (shell-command-to-string
                      "$SHELL --login -c 'echo $PATH'"
                            ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;; set env var PATH, by appending a new path to existing PATH value
(setenv "PATH"
        (concat
         "/Users/sharonavni/go/bin" path-separator
         (getenv "PATH")))
(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer dw/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer dw/ctrl-c-keys
    :prefix "C-c"))
;;}}}

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-c c") (lambda() (interactive)(find-file "~/.emacs.d/init.el")))

; Don't create annoying file#.d
(setq create-lockfiles nil)
; Set up package.el to work with MELPA
(package-initialize)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(add-hook 'prog-mode-hook (lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'prog-mode-hook 'electric-pair-mode)

(when (fboundp 'add-to-load-path)
  (add-to-load-path (file-name-directory (buffer-file-name))))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)
           (setq doom-modeline-project-detection 'project)
           (setq doom-modeline-icon t)
           (doom-modeline-vcs-max-length 60)))
(setq-default frame-title-format "%b (%f)")
;(column-number-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind ("C-M-p" . projectile-find-file)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  )
(setq doom-modeline-buffer-file-name-style 'relative-to-project)

(use-package counsel-projectile
  :disabled
  :after projectile
  :config
  (counsel-projectile-mode))


(use-package vterm
    :ensure t)

(setq vterm-toggle-fullscreen-p nil)
(add-to-list 'display-buffer-alist
             '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                (display-buffer-reuse-window display-buffer-at-bottom)
                ;;(display-buffer-reuse-window display-buffer-in-direction)
                ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                ;;(direction . bottom)
                ;;(dedicated . t) ;dedicated is supported in emacs27
                (reusable-frames . visible)
                (window-height . 0.3)))

(global-set-key (kbd "C-c t") 'vterm-toggle)


(setq projectile-enable-caching t)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(setq ring-bell-function 'ignore)

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)   ; or use a nicer switcher, see below
  :init
  (persp-mode))

(use-package flycheck :ensure)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

;;{{{ helm
(defun helm-yank-selection-to-ring (arg)
  "Set minibuffer contents to current display selection.
With a prefix arg set to real value of current selection."
  (interactive "P")
  (with-helm-alive-p
    (helm-run-after-exit
    (let ((str (format "%s" (helm-get-selection nil (not arg)))))
      (kill-new str)))))

(use-package helm
  :ensure t
  :demand
  :bind* (:map helm-map
          ("C-a" . helm-yank-selection-to-ring)
          ([tab] . helm-execute-persistent-action))
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)
         ("C-x c o" . helm-occur)) ;SC
         ("M-y" . helm-show-kill-ring) ;SC
         ("C-x r b" . helm-filtered-bookmarks) ;SC
	 :preface (require 'helm-config)
	 :config (helm-mode 1))
(persp-mode)
(global-undo-tree-mode)
(shackle-mode)
;;}}}

(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(global-set-key (kbd "C-<backspace>") 'switch-to-last-buffer)


(defun open-compilation ()
  (interactive)
  (popwin:popup-buffer "*compilation*"))

(defun save-and-recompile ()
  (interactive)
  (save-buffer)
  (recompile))

(dw/leader-key-def
  "bb" 'helm-buffers-list
  "wd" 'evil-window-delete
  "pf" 'projectile-find-file
  "pp" 'projectile-switch-project
  "pt" 'treemacs
  "xv" 'consult-ripgrep
  "pd" 'projectile-dired
  "pc" 'projectile-invalidate-cache
  "cr" 'save-and-recompile
  "sp" 'helm-projectile-ag
  "sP" 'helm-projectile-rg
  "sl" 'helm-resume
  "ss" 'swiper
  "~"  'open-compilation
  "pl" 'projectile-persp-switch-project
  "ee" 'evil-goto-error
  "fd" 'dumb-jump-go-prompt
  "dd" 'my-dumb-jump-helm
  "dj" 'dumb-jump-go
  )
;;{{{ Custom
;; Initialize package sources
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-show-quick-access t nil nil "Customized with use-package company")
 '(custom-safe-themes
   '("7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "1bddd01e6851f5c4336f7d16c56934513d41cc3d0233863760d1798e74809b4b" "e19ac4ef0f028f503b1ccafa7c337021834ce0d1a2bca03fcebc1ef635776bea" "4a5aa2ccb3fa837f322276c060ea8a3d10181fecbd1b74cb97df8e191b214313" "c4063322b5011829f7fdd7509979b5823e8eea2abf1fe5572ec4b7af1dd78519" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" default))
 '(display-line-numbers 'relative)
 '(evil-want-Y-yank-to-eol t)
 '(godef-command "~/go/bin/godef")
 '(helm-minibuffer-history-key "M-p")
 '(magit-revision-insert-related-refs nil)
 '(marginalia-mode t)
 '(package-selected-packages
   '(eglot company-jedi evil-args vterm-toggle popper vterm tree-sitter-indent tree-sitter-langs tree-sitter chatgpt editorconfig copilot quelpa-use-package quelpa folding flycheck-rust toml-mode rustic rust-mode helm-xref dumb-jump lsp-ui flycheck-golangci-lint flymake-go multiple-cursors evil-escape evil-mc git-timemachine persp-projectile drag-stuff move-text bm company-tabnine iedit evil-multiedit evil-easymotion evil-snipe shackle evil-collection evil-numbers go-mode virtualenv helm-flyspell helm-file-preview helm-rg ag helm-ag origami zoom-window zoom evil-visualstar helm-projectile perspective general marginalia rainbow-delimiters doom-modeline key-chord which-key use-package smex slime reveal-in-osx-finder proof-general projectile-ripgrep powerline pdf-tools org-roam org-bullets olivetti minizinc-mode maude-mode magit lsp-java js2-mode jedi haskell-mode golden-ratio focus expand-region exec-path-from-shell evil erlang doom-themes diff-hl define-word d-mode counsel-projectile company-coq clj-refactor auto-compile ac-dcd))
 '(projectile-mode t nil (projectile))
 '(warning-suppress-log-types '((comp)))
 '(warning-suppress-types '((use-package) (use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;}}}

;;}}}

;;{{{ lsp-mode

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

;;}}}

;;{{{ Company and Yasnippet
(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  (company-show-numbers t)
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
	      ("C-n". company-select-next)
	      ("C-p". company-select-previous)
	      ("M-<". company-select-first)
	      ("M->". company-select-last))
  (:map company-mode-map
          ("<tab>". tab-indent-or-complete)
          ("TAB". tab-indent-or-complete)))

; Install copilot
(add-to-list 'load-path "/Users/sharonavni/.emacs.d/elpa/copilot.el")
(require 'copilot)
(add-hook 'prog-mode-hook 'copilot-mode)
(with-eval-after-load 'company
  ;; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends))

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

; complete by copilot first, then company-mode
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

; modify company-mode behaviors
(with-eval-after-load 'company
  ; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends)
  ; enable tab completion
  (define-key company-mode-map (kbd "<tab>") 'my-tab)
  (define-key company-mode-map (kbd "TAB") 'my-tab)
  (define-key company-active-map (kbd "<tab>") 'my-tab)
  (define-key company-active-map (kbd "TAB") 'my-tab))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(use-package company-tabnine :ensure t)

; Install chatgpt in emacs
(add-to-list 'load-path "/Users/sharonavni/.emacs.d/elpa/ChatGPT.el")
(setq chatgpt-repo-path (expand-file-name "chatGPT.el/" "/Users/sharonavni/.emacs.d/elpa"))
(require 'chatgpt)

(global-set-key (kbd "C-c q") 'chatgpt-query)

;;}}}
;;{{{ Evil mode

;; Download Evil

;; Must be set before loading evil
(setq evil-want-keybinding nil)

(unless (package-installed-p 'evil)
  (package-install 'evil))


;; Enable Evil
(setq evil-want-C-u-scroll t)
(setq evil-want-Y-yank-to-eol t)

(require 'evil)
(evil-mode 1)

(defun evil-paste-after-from-0 ()
  (interactive)
  (let ((evil-this-register ?0))
    (call-interactively 'evil-paste-after)))

(defun add-semi-colon ()
  "Adds a semicolon to the end of the current line."
  (interactive)
  (save-excursion
    (end-of-line)
    (insert ";")))


(setq evil-kill-on-visual-paste nil)
(define-key evil-normal-state-map (kbd "C-:") 'add-semi-colon)

;; Globally

(require 'evil-args)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)

(evil-set-undo-system 'undo-tree)

(global-evil-visualstar-mode)
(define-key evil-normal-state-map (kbd "M-<up>") 'drag-stuff-up)
(define-key evil-normal-state-map (kbd "M-<down>") 'drag-stuff-down)

(defun my/evil-shift-right ()
  (interactive)
  (evil-shift-right evil-visual-beginning evil-visual-end)
  (evil-normal-state)
  (evil-visual-restore))

(defun my/evil-shift-left ()
  (interactive)
  (evil-shift-left evil-visual-beginning evil-visual-end)
  (evil-normal-state)
  (evil-visual-restore))

(evil-define-key 'visual global-map (kbd ">") 'my/evil-shift-right)
(evil-define-key 'visual global-map (kbd "<") 'my/evil-shift-left)
(evil-define-key 'normal global-map (kbd "C-j") 'helm-all-mark-rings)

(require 'evil-multiedit)
(evil-multiedit-default-keybinds)

(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))

(global-set-key (kbd "C-;") 'iedit-dwim)

(require 'drag-stuff)

(require 'evil-exchange)
(evil-exchange-install)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(evil-lion-mode)

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-collection-magit-state 'normal)
  (setq evil-collection-magit-use-y-for-yank t)
  (setq evil-collection-magit-want-horizontal-movement t)
  (evil-collection-init))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(evil-escape-mode)
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)
(key-chord-define evil-insert-state-map  "df" 'evil-normal-state)

(global-set-key (kbd "C-]") 'evil-escape)
(global-set-key (kbd "<S-return>") 'avy-goto-word-0)
(evil-global-set-key 'normal "L" 'evil-end-of-line)
(evil-global-set-key 'visual "L" 'evil-end-of-line)
(evil-global-set-key 'normal "H" 'evil-first-non-blank)
(evil-global-set-key 'visual "H" 'evil-first-non-blank)
(evil-global-set-key 'normal "L" 'evil-end-of-line)


(evil-add-command-properties 'dumb-jump-go :jump t)

;;}}}
;;{{{ git
(evil-define-key 'normal magit-blame-mode-map (kbd "q") 'magit-blame-quit)

(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

(global-git-gutter+-mode)

(setq evil-magit-want-horizontal-movement t)
(setq magit-commit-show-diff nil
      magit-revert-buffers 1)

;; Remove hooks to make magit faster
;; (add-hook 'magit-status-sections-hook 'magit-insert-status-headers)
(add-hook 'magit-status-sections-hook 'magit-insert-error-header)
(add-hook 'magit-status-sections-hook 'magit-insert-diff-filter-header)
(add-hook 'magit-status-sections-hook 'magit-insert-head-branch-header)
(add-hook 'magit-status-sections-hook 'magit-insert-upstream-branch-header)
(add-hook 'magit-status-sections-hook 'magit-insert-push-branch-header)
(add-hook 'magit-status-sections-hook 'magit-insert-merge-log)
(add-hook 'magit-status-sections-hook 'magit-insert-rebase-sequence)
(add-hook 'magit-status-sections-hook 'magit-insert-am-sequence)
(add-hook 'magit-status-sections-hook 'magit-insert-sequencer-sequence)
(add-hook 'magit-status-sections-hook 'magit-insert-bisect-output)
(add-hook 'magit-status-sections-hook 'magit-insert-bisect-rest)
(add-hook 'magit-status-sections-hook 'magit-insert-bisect-log)
(add-hook 'magit-status-sections-hook 'magit-insert-unstaged-changes)
(add-hook 'magit-status-sections-hook 'magit-insert-staged-changes)
(add-hook 'magit-status-sections-hook 'magit-insert-recent-commits)

;(remove-hook 'magit-status-sections-hook 'magit-insert-recent-commits)
;(remove-hook 'magit-status-sections-hook 'magit-insert-untracked-files)
;(remove-hook 'magit-status-sections-hook 'magit-insert-recent-commits)
;(remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
(remove-hook 'magit-status-sections-hook 'magit-insert-stashes)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
(remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)

(setenv "EDITOR" "emacsclient")
(setenv "GIT_SEQUENCE_EDITOR" "emacsclient")
(setenv "GIT_EDITOR" "emacsclient")
(setenv "PAGER" "")
(setenv "GIT_PAGER" "")

(defun mediate ()
  (interactive)
  (compile "git mediate -d "))


(defun horizontal-magit-log nil
  (interactive)
  (let ((split-width-threshold nil)
        (split-height-threshold 0))
    (call-interactively 'magit-log-head)))

(defun horizontal-shell-split nil
  (interactive)
  (let ((split-width-threshold nil)
        (split-height-threshold 0))
    (call-interactively 'shell)))

(defun my/magit-update-submodules ()
  "Update submodules in the current Git repository."
  (interactive)
    (magit-run-git-async "submodule" "update" "--init" "--recursive"))
;(add-hook 'magit-post-refresh-hook 'my/magit-update-submodules)

;; (defun custom-magit-checkout-branch (revision)
;;   "Checks out a branch updating the mode line (reverts the buffer)."
;;   (interactive (list (magit-read-other-branch "Checkout")))
;;   (magit-branch-or-checkout revision)
;;   (revert-buffer t t)
;;   (magit-run-git-async "submodule" "update" "--init" "--recursive"))
(defun refresh-vc-state (&rest r) (message "%S" (current-buffer))(vc-refresh-state))
(advice-add 'magit-checkout-revision :after 'refresh-vc-state '((name . "magit-refresh-on-checkout-revision")))
(advice-add 'magit-branch-create :after 'refresh-vc-state '((name . "magit-refresh-on-branch-create")))
(advice-add 'magit-branch-and-checkout :after 'refresh-vc-state '((name .  "magit-refresh-on-checkout-and-branch")))
(advice-add 'magit-branch-or-checkout :after 'refresh-vc-state '((name .  "magit-refresh-on-branch-or-checkout")
                                                                 (my/magit-update-submodules)))

(setq magit-list-refs-sortby "-creatordate")

(dw/leader-key-def
  "gg" 'magit-status
  "gb" 'magit-blame-addition
  "gf" 'magit-file-dispatch ; shows all commits that touched current file
  "gs" 'git-gutter+-stage-hunks
  "gu" 'git-gutter+-revert-hunk
  "gp" 'git-gutter+-show-hunk-inline-at-point
  "gj" 'git-gutter+-next-hunk
  "gk" 'git-gutter+-previous-hunk
  "gt" 'git-timemachine
  "gl" 'horizontal-magit-log
  "gL" 'magit-log-head
  "g[" 'mediate
  ;"gcb" 'custom-magit-checkout-branch
  "gc" 'magit-branch-or-checkout
  "gx" 'my/magit-update-submodules
  "grc" 'magit-rebase-continue
  "gra" 'magit-rebase-abort)
;;}}}
;;{{{ Rust

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c d" . dap-hydra)
              ("C-c C-c h" . lsp-ui-doc-glance))
  :config
  ;; uncomment for less flashiness
  ;(setq lsp-eldoc-hook nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)

  (setq rustic-lsp-client 'eglot)
 ;; comment to disable rustfmt on save
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(setq rustic-analyzer-command '("~/.cargo/bin/rust-analyzer"))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (company-mode)
  (add-hook 'before-save-hook 'eglot-format nil t))

(setq rust-format-on-save t)
(use-package toml-mode :ensure)

;;}}}
;;{{{ D

(require 'ac-dcd)
(require 'd-mode)

(setq ac-dcd-flags (quote
    ("-I~/projects/wekapp" "-I~/projects/wekapp/weka/external/carblue_sodium/deimos" "-I~/projects/wekapp/weka/submodules/mecca/src" "-I~/projects/wekapp/build/packages/agent/src" "-I~/projects/wekapp/build/libdparse/src" "-I~/projects/wekapp/weka/external/deimos/openssl" "-I~/projects/wekapp/weka/external/dini/source" "-I~/projects/wekapp/weka/external/zstd-d/source" "-I~/projects/wekapp/weka/external/jwtd/source" "-I~/projects/wekapp/weka/external/elf-d/source" "-I~/projects/wekapp/weka/external/msgpack-d/src" "-I/usr/local/include/d" "-I~/work/repos/ldc")))

(add-to-list 'ac-modes 'd-mode)
(define-key d-mode-map [(control ?`)] 'company-complete)

(setq ac-dcd-executable "/usr/local/bin/dcd-client")
(setq ac-dcd-server-executable "/usr/local/bin/dcd-server")

(defun get-module-name ()
  "Extract the module name defined at the top of the current buffer using regex."
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "^module \\(.*\\);$" nil t)
    (match-string 1)))

(defun import-dlang-symbol ()
  "Import a D language symbol from its definition file."
  (interactive)
  (let ((symbol (symbol-at-point))
        (original-buffer (current-buffer)))
    (if symbol
        (let ((filename (my-goto-definition-with-symbol symbol)))
          (if filename
              (let* ((module (get-module-name))
                     (import-string (concat "import " module ": " (symbol-name symbol) ";"))
                     (indentation (concat (make-string (current-column) ?\s))))
                (with-current-buffer original-buffer
                  (save-excursion
                    (goto-char (line-beginning-position))
                    (insert (concat indentation import-string "\n")))
                  (kill-buffer (find-buffer-visiting filename))
                  (switch-to-buffer original-buffer)
                  (message "Imported symbol '%s' from file '%s' in module '%s'" symbol filename module)))
            (message "Could not find definition for symbol '%s'" symbol)))
      (message "No symbol found at point"))))

(defun my-goto-definition-with-symbol (symbol &optional point)
  "Goto declaration of SYMBOL.
If ac-dcd-goto-definition fails, call dumb-jump-go."
  (interactive)
  (condition-case nil
      (ac-dcd-goto-definition symbol)
    (error (dumb-jump-go))))

(defun my-goto-definition ()
  "Goto declaration of symbol at point.
If ac-dcd-goto-definition fails, call dumb-jump-go."
  (interactive)
  (condition-case nil
      (ac-dcd-goto-definition)
    (error (dumb-jump-go))))

(global-set-key (kbd "C-c i") 'import-dlang-symbol)

(defun ac-dcd-setup ()
;  (auto-complete-mode t)
  (when (featurep 'yasnippet) (yas-minor-mode-on))
  (ac-dcd-maybe-start-server)
  (ac-dcd-add-imports)
  (add-to-list 'ac-sources 'ac-source-dcd)
  (define-key d-mode-map (kbd "C-c ?") 'ac-dcd-show-ddoc-with-buffer)
  (define-key d-mode-map (kbd "C-c .") 'my-goto-definition)
  (define-key d-mode-map (kbd "C-c /") (lambda () (interactive) (ac-dcd-init-server) (ac-dcd-goto-definition)))

  (define-key d-mode-map (kbd "C-c ,") 'ac-dcd-goto-def-pop-marker)
  (define-key d-mode-map (kbd "C-c s") 'ac-dcd-search-symbol)

  (when (featurep 'popwin)
    (add-to-list 'popwin:special-display-config
                 `(,ac-dcd-error-buffer-name :noselect t))
    (add-to-list 'popwin:special-display-config
                 `(,ac-dcd-document-buffer-name :position right :width 80))
    (add-to-list 'popwin:special-display-config
                 `(,ac-dcd-search-symbol-buffer-name :position bottom :width 5))))

(use-package d-mode
  :hook (d-mode . my-d-hook))

(defun my-d-hook ()
  (make-local-variable 'column-enforce-column)
  (local-set-key "\C-i" #'company-indent-or-complete-common)
  (setq column-enforce-column 120)
  (setq fill-column 120)
  (setq tab-width 4)
  (setq c-basic-offset 4
        indent-tabs-mode nil)
  (with-eval-after-load 'lsp-mode (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("serve-d"))
                    :major-modes '(d-mode)
                    :server-id 'serve-d)))
  (company-mode 1)
  (ac-dcd-setup)
  (lsp 1))

(defun wldc-run ()
  (interactive)
  (save-buffer)
  (compile (concat "python3 " (projectile-project-root) "scripts/build/wldc -o- " (buffer-file-name))))

(defun wldc-ut-run ()
  (interactive)
  (compile (concat "python3 " (projectile-project-root) "scripts/build/wldc --unittest -o- " (buffer-file-name))))

(defun wldc-check-all ()
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "scripts/build/check_all")))

(defun wldc-check-all-ut ()
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "scripts/build/check_all weka --unittest")))


(dw/leader-key-def
  "cc" 'wldc-run
  "cu" 'wldc-ut-run
  "cC" 'wldc-check-all
  "cU" 'wldc-check-all-ut)

;;}}}
;;{{{ Go

(defun go-build-proj ()
  (interactive)
  (let ((default-directory (concat (projectile-project-root) "/build/packages/hostside/upgrade/cmd")))
    (compile "go build")))

;; (defun go-make ()
;;   (interactive)
;;   (compile "go build"))
(use-package go-mode
  :ensure t
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ("C-c C-j" . lsp-find-definition)
         ("C-c C-d" . lsp-describe-thing-at-point)
         ("C-c b"   . go-build-proj)
         ("C-c C-r" . lsp-find-references)))
(add-to-list 'load-path "~/go/bin/goflymake")
(add-to-list 'load-path "~/go/bin/goimports")

(require 'flymake-go)

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  ;(setq gofmt-command "goimports")
  ; Call Gofmt before saving
  ;(add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  (company-mode))

(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)

;; Go - lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook 'my-go-mode-hook)
(add-hook 'go-mode-hook #'yas-minor-mode)

;;}}}
;;{{{ Python
(require 'python)

(defun setup-python ()
  (company-mode)
  (eglot-ensure))

(add-hook 'python-mode-hook 'setup-python)
(add-hook 'python-ts-mode-hook 'setup-python)

;;}}}

;;{{{ Jumping
(evil-add-command-properties 'godef-jump :jump t)
(evil-add-command-properties 'company-dcd-goto-definition :jump t)
(evil-add-command-properties 'helm-do-grep :jump t)
(evil-add-command-properties 'helm-projectile-grep :jump t)
(evil-add-command-properties 'ac-dcd-goto-definition :jump t)
(evil-add-command-properties 'my-goto-definition :jump t)
;;}}}

;;{{{ Tree Sitter
(require 'tree-sitter)
(require 'tree-sitter-langs)

(setq major-mode-remap-alist
 '((python-mode . python-ts-mode)))

;;}}}

;;{{{ Eglot
(require 'eglot)
(define-key eglot-mode-map (kbd "C-c <tab>") #'company-complete) ; initiate the completion manually
(define-key eglot-mode-map (kbd "C-c e n") #'flymake-goto-next-error)
(define-key eglot-mode-map (kbd "C-c e p") #'flymake-goto-prev-error)
(define-key eglot-mode-map (kbd "C-c e r") #'eglot-rename)

(setq eldoc-echo-area-use-multiline-p nil)

;;}}}


(add-hook 'c-mode-hook
'(lambda ()
    (c-set-style "ellemtel")))
