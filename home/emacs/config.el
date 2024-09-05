;; -*- lexical-binding: t; -*-

(defmacro after! (files &rest body)
  "Evaluate BODY after FILES have been loaded. Thin wrapper
 around `with-eval-after-load', inspired by Doom."
  (cond
   ((null files)
    `(progn ,@body))
   ((listp files)
    `(with-eval-after-load ',(car files)
       (after! ,(cdr files) ,@body)))
   (t
    `(with-eval-after-load ',files
       ,@body))))
(put 'after! 'lisp-indent-function 'defun)

(defmacro idle-load (package)
  "Load PACKAGE after Emacs has been idle for a second."
  `(run-with-idle-timer 1 nil #'require ,package))

(defmacro add-hooks (&rest hooks)
  `(progn
     ,@(mapcar (lambda (hook)
                 `(add-hook ',(car hook) #',(cdr hook)))
               hooks)))

(defmacro autoload-many (filename interactive &rest funcs)
  `(progn
     ,@(mapcar (lambda (func)
                 `(autoload ,func ,filename nil ,interactive))
               funcs)))

(defmacro cmd! (&rest body)
  "Wrap BODY in an interactive lambda definition with no arguments."
  `(lambda ()
     (interactive)
     ,@body))

(defun my/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.3f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done)
  (gcmh-mode))
(add-hook 'emacs-startup-hook #'my/display-startup-time 50)

(after! gcmh
  (setopt gcmh-idle-delay 'auto
          gcmh-auto-idle-delay-factor 10
          gcmh-high-cons-threshold (* 16 1024 1024)))

(defvar my/private
  (json-read-file (expand-file-name "private.json" user-emacs-directory))
  "My private configuration data.")

(defun my/private (keys)
  "Return value of `my/private' by recursively following KEYS."
  (map-nested-elt my/private keys))

(require 'f)
(eval-when-compile
  (require 'cl-lib))

(setq-default no-littering-etc-directory
              (expand-file-name "emacs/" (getenv "XDG_CONFIG_HOME"))
              no-littering-var-directory
              (expand-file-name "emacs/" (getenv "XDG_DATA_HOME")))
(require 'no-littering)

(setq-default make-backup-files nil
              create-lockfiles nil)

(setopt auto-save-default nil)
(auto-save-visited-mode)

(idle-load 'autorevert)
(after! autorevert
  (setopt global-auto-revert-non-file-buffers t
          auto-revert-interval 1)
  (global-auto-revert-mode))

(recentf-mode)
(setopt recentf-max-saved-items 200)

(save-place-mode)

(savehist-mode)
(setopt history-length 250
        history-delete-duplicates t)
(add-to-list 'savehist-additional-variables 'corfu-history)

(setq-default use-short-answers t)

(add-hook 'prog-mode-hook #'smartparens-mode)

(setq-default scroll-conservatively 10
              scroll-margin 4
              scroll-preserve-screen-position t
              auto-window-vscroll nil
              fast-but-imprecise-scrolling t)

(setq-default indent-tabs-mode nil
              sentence-end-double-space nil
              tab-width 4
              fill-column 80
              comment-multi-line t
              require-final-newline t
              comment-empty-lines 'eol)

(persistent-scratch-setup-default)

(add-hook 'prog-mode-hook #'subword-mode)

(setopt auth-sources '(default))

(setopt save-interprogram-paste-before-kill t)

(setopt warning-minimum-level :error)

(winner-mode)

(setopt enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode)

(setopt comint-prompt-read-only t)

(setopt compilation-always-kill t
        compilation-ask-about-save nil
        compilation-scroll-output 'first-error)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(global-visual-line-mode)

(setq-default frame-title-format '("" "%b - Emacs"))

(set-fringe-mode '(6 . 2))

(custom-set-faces
 '(default           ((t (:font "Iosevka SS18"       :height 140))))
 '(fixed-pitch       ((t (:font "Iosevka Fixed SS18" :height 140))))
 '(fixed-pitch-serif ((t (:font "Iosevka Slab"       :height 140))))
 '(variable-pitch    ((t (:font "Iosevka Aile"       :height 140)))))

(autoload #'nerd-icons-set-font "nerd-icons" "Modify nerd font charsets to use FONT-FAMILY for FRAME." nil)
(add-hook 'server-after-make-frame-hook #'nerd-icons-set-font)

(add-hook 'prog-mode-hook #'ligature-mode)
(after! ligature
  (ligature-set-ligatures
   'prog-mode
   '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
     ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
     "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
     "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
     "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
     "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
     "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
     "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
     ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
     "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
     "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
     "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
     "\\\\" "://")))

(require 'catppuccin-theme)
(setopt catppuccin-flavor 'macchiato
        catppuccin-italic-comments t
        catppuccin-height-doc-title 2.0
        catppuccin-height-title-1 1.5
        catppuccin-height-title-2 1.3
        catppuccin-height-title-3 1.2)
(load-theme 'catppuccin :no-confirm)

(custom-set-faces
 `(org-document-info-keyword ((t :inherit (shadow fixed-pitch))))
 `(org-meta-line             ((t :inherit (shadow fixed-pitch))))
 `(org-drawer                ((t :inherit (shadow fixed-pitch))))
 `(org-special-keyword       ((t :inherit fixed-pitch)))
 `(org-property-value        ((t :inherit shadow)))
 `(org-indent                ((t :inherit (fixed-pitch org-hide))))
 `(org-table                 ((t :inherit fixed-pitch)))
 `(org-block                 ((t :inherit fixed-pitch
                                 :foreground unspecified)))
 `(org-agenda-structure      ((t :height 1.3))))

(minions-mode)

(require 'nyan-mode)
(setopt nyan-bar-length 24
        nyan-minimum-window-width 48
        nyan-wavy-trail t)
(nyan-mode)

(require 'spacious-padding)

(setopt spacious-padding-subtle-mode-line
        '(:mode-line-active error)
        spacious-padding-widths
        (plist-put spacious-padding-widths
                   :right-divider-width 0))

(spacious-padding-mode)

(add-hook 'eldoc-mode-hook #'eldoc-box-hover-at-point-mode)

(after! eldoc-box
  (custom-set-faces
   `(eldoc-box-border ((t :background ,(catppuccin-get-color 'base))))
   '(eldoc-box-body ((t :inherit variable-pitch))))
  (setcdr (assq 'left-fringe eldoc-box-frame-parameters) 2)
  (setcdr (assq 'right-fringe eldoc-box-frame-parameters) 2))

(after! eldoc-box
  (defun my/eldoc-box-at-point-position-function (width height)
    "Positions the `eldoc-box' popup above the text rather than below
it by adjusting the return value of
`eldoc-box--default-at-point-position-function-1'."
    (cl-destructuring-bind (x . y)
        (eldoc-box--default-at-point-position-function-1 width height)
      (let* ((ch (frame-char-height)))
        ;; Up is negative
        (cons x (max 0 (- y ch height))))))
  (setopt eldoc-box-at-point-position-function #'my/eldoc-box-at-point-position-function))

(dashboard-setup-startup-hook)

(setopt initial-buffer-choice
        (lambda ()
          (get-buffer-create dashboard-buffer-name)))

(setopt dashboard-startup-banner (expand-file-name "logo.webp"
                                                   user-emacs-directory)
        dashboard-center-content t
        dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (bookmarks . 5)
                          (registers . 5))
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        ;; For some reason this is getting set to 'nil'
        dashboard-heading-icons '((recents . "nf-oct-history")
                                  (bookmarks . "nf-oct-bookmark")
                                  (agenda . "nf-oct-calendar")
                                  (projects . "nf-oct-rocket")
                                  (registers . "nf-oct-database"))
        dashboard-set-file-icons t
        dashboard-projects-backend 'project-el
        dashboard-projects-switch-function #'project-switch-project
        dashboard-remove-missing-entry t)

(after! org
  (setf (alist-get 'agenda dashboard-items) 5))

(autoload #'indent-bars-mode "indent-bars" "Indicate indentation with configurable bars." t)
(add-hook 'prog-mode-hook #'indent-bars-mode)

(dolist (map '(my/buffer-map
               my/git-map
               my/notes-map
               my/open-map
               my/toggle-map
               my/window-map))
  (unless (boundp map)
    (define-prefix-command map)))

(bind-keys ("C-c b" . my/buffer-map)
           ("C-c g" . my/git-map)
           ("C-c n" . my/notes-map)
           ("C-c o" . my/open-map)
           ("C-c t" . my/toggle-map)
           ("C-c w" . my/window-map))

(bind-keys :map my/buffer-map
           ("b" . switch-to-buffer)
           ("k" . (lambda () (interactive) (kill-buffer)))
           ("q" . kill-buffer-and-window))

(bind-keys :map my/window-map
           ("u" . windmove-up)
           ("n" . windmove-left)
           ("e" . windmove-down)
           ("i" . windmove-right)
           ("h" . split-window-below)
           ("v" . split-window-right)
           ("w" . other-window)
           ("k" . delete-window)
           ("o" . delete-other-windows)
           ("m" . winner-undo)
           ("r" . winner-redo)
           ("T" . transpose-frame)
           ("^" . tear-off-window))

(bind-key "C-`" #'previous-buffer)

(global-devil-mode)

(setopt devil-repeatable-keys nil)

(define-advice devil--update-command-loop-info
    (:after (&rest _) set-original-command)
  (setq this-original-command real-this-command))

(repeat-mode)

(setopt repeat-exit-timeout 3)

(defvar-keymap my/movement-repeat-map
  :repeat t
  "n" #'next-line
  "p" #'previous-line
  "f" #'forward-char
  "b" #'backward-char)

(defvar-keymap my/word-repeat-map
  :repeat t
  "f" #'forward-word
  "b" #'backward-word)

(defvar-keymap my/sentence-repeat-map
  :repeat t
  "e" #'forward-sentence
  "a" #'backward-sentence)

(defvar-keymap my/paragraph-repeat-map
  :repeat t
  "}" #'forward-paragraph
  "{" #'backward-paragraph)

(defvar-keymap my/sexp-repeat-map
  :repeat t
  "f" #'forward-sexp
  "b" #'backward-sexp)

(defvar-keymap my/undo-repeat-map
  :repeat t
  "/" #'undo)

(defvar-keymap my/delete-repeat-map
  :repeat t
  "d" #'delete-char)

(bind-keys ("C-S-c" . mc/edit-lines)
           ("C->" . mc/mark-next-like-this)
           ("C-<" . mc/mark-previous-like-this)
           ("C-M->" . mc/mark-all-like-this))

(after! multiple-cursors-core
  (define-advice mc/make-a-note-of-the-command-being-run
      (:after (&rest _) dont-note-devil)
    (when (eq mc--this-command 'devil)
      (setq mc--this-command nil))))

(bind-keys ("M-o" . ace-window)
           ([remap other-window] . ace-window))

(after! ace-window
  (ace-window-display-mode)
  (ace-window-posframe-mode)
  (setopt aw-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o)
          aw-scope 'frame))

(custom-set-faces
 '(aw-leading-char-face ((t :inherit error :height 480))))

(bind-key "<escape>" #'keyboard-escape-quit)

(after! transient
  (bind-key "<escape>" #'transient-quit-one transient-base-map))

(bind-keys ([remap goto-char] . avy-goto-char-timer)
           :map goto-map
           ("a" . casual-avy-tmenu))

(after! avy
  (setopt avy-timeout-seconds 0.3
          ;; Homerow on Colemak DH
          avy-keys '(?a ?r ?s ?t ?n ?e ?i ?o)))

(defun my/avy-action-embark (pt)
  "Use Embark as an Avy dispatch action."
  (unwind-protect
      (save-excursion
        (goto-char pt)
        (embark-act))
    (select-window
     (cdr (ring-ref avy-ring 0))))
  t)

(after! avy
  (setf (alist-get ?. avy-dispatch-alist) #'my/avy-action-embark))

(require 'vertico)

(add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

(bind-keys ("M-S-s" . vertico-suspend)
           ("M-S-r" . vertico-repeat)
           :map vertico-map
           ("RET" . vertico-directory-enter)
           ("DEL" . vertico-directory-delete-char)
           ("M-DEL" . vertico-directory-delete-word)
           ("M-j" . vertico-quick-jump)
           ("M-P" . vertico-repeat-previous)
           ("M-N" . vertico-repeat-nex))

(setopt vertico-count 15
        vertico-cycle t
        vertico-resize nil
        vertico-quick1 "arstneio"
        vertico-quick2 vertico-quick1)

(vertico-mode)

(defvar-keymap my/vertico-repeat-map
  :repeat t
  "n" #'vertico-next
  "p" #'vertico-previous)

(require 'orderless)
(setopt completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion))))

(bind-keys ([remap yank-pop] . consult-yank-pop)
           ([remap switch-to-buffer] . consult-buffer)
           ([remap goto-line] . consult-goto-line)
           ([remap imenu] . consult-imenu)
           ([remap execute-extended-command-for-buffer] . consult-mode-command)
           ([remap repeat-complex-command] . consult-complex-command)
           ([remap project-switch-to-buffer] . consult-project-buffer)
           ([remap previous-matching-history-element] . consult-history)
           ([remap next-matching-history-element] . consult-history)
           ([remap bookmark-jump] . consult-bookmark)
           ([remap point-to-register] . consult-register-store)
           ([remap jump-to-register] . consult-register-load)
           ("C-x r J" . consult-register)
           :map goto-map
           ("f" . consult-flymake)
           ("I" . consult-imenu-multi)
           ("h" . consult-org-heading)
           ("m" . consult-mark)
           ("M" . consult-global-mark)
           :map search-map
           ("g" . consult-ripgrep)
           ("l" . consult-line))

(bind-keys ("C-x C-d" . consult-dir)
           :map vertico-map
           ("C-x C-d" . consult-dir)
           ("C-x C-j" . consult-dir-jump-file))

(after! consult-dir
  (defvar my/consult-dir-source-zoxide
    `(:name "Zoxide dirs"
            :narrow ?z
            :category file
            :face consult-file
            :history file-name-history
            :enabled ,(lambda () (featurep 'zoxide))
            :items ,#'zoxide-query)
    "Source for `consult-dir' using `zoxide.el'.")
  (cl-pushnew 'my/consult-dir-source-zoxide consult-dir-sources))

(require 'marginalia)
(bind-key "M-A" #'marginalia-cycle)
(marginalia-mode)

(bind-keys ("C-." . embark-act)
           ("C-;" . embark-dwim))

(setopt prefix-help-command #'embark-prefix-help-command)

(after! embark
  ;; Needed for `eww-download-directory' in `embark-download-url'.
  (require 'eww))

(defun my/corfu-enable-in-minibuffer ()
 "Enable Corfu in the minibuffer if `completion-at-point' is bound."
 (when (where-is-internal #'completion-at-point
                          (list (current-local-map)))
   (corfu-mode)))

(add-hooks   (prog-mode-hook        . corfu-mode)
             (text-mode-hook        . corfu-mode)
             (minibuffer-setup-hook . my/corfu-enable-in-minibuffer))

(after! corfu
  (bind-key "RET" nil 'corfu-map)
  (setopt tab-always-indent 'complete
          corfu-auto t
          corfu-auto-prefix 2
          corfu-cycle t
          corfu-preview-current t)
  (corfu-popupinfo-mode)
  (corfu-history-mode))
   
(custom-set-faces
 '(corfu-default ((t (:inherit fixed-pitch)))))

(defvar-keymap my/corfu-repeat-map
  :repeat t
  "n" #'corfu-next
  "p" #'corfu-previous)

(defun my/add-cape-capfs ()
  (dolist (f #'(cape-file cape-elisp-block cape-emoji cape-tex))
    (cl-pushnew f completion-at-point-functions)))
(add-hook 'text-mode-hook #'my/add-cape-capfs)

(after! eglot
  (bind-keys :map eglot-mode-map
             ("C-c c a" . eglot-code-actions)
             ("C-c c f" . eglot-format)
             ("C-c c r" . eglot-rename))
  (setopt eglot-autoshutdown t)
  (setf (alist-get '(markdown-mode org-mode text-mode) eglot-server-programs
                   nil nil #'equal)
        '("ltex-ls")))

(custom-set-faces
 '(eglot-inlay-hint-face ((t (:inherit font-lock-comment-face)))))

(after! eglot
  (setf (alist-get 'eglot-capf completion-category-overrides)
        '((styles orderless basic))))

(after! eglot
  (require 'eglot-booster)
  (eglot-booster-mode))

(bind-keys ("C-c C-d"                 . helpful-at-point)
           ([remap describe-function] . helpful-callable)
           ([remap describe-variable] . helpful-variable)
           ([remap describe-key]      . helpful-key)
           ([remap describe-command]  . helpful-command)
           ([remap describe-symbol]   . helpful-symbol))

(cl-pushnew '((major-mode . helpful-mode)
              (display-buffer-reuse-mode-window display-buffer-at-bottom)
              (reusable-frames . nil))
            display-buffer-alist
            :test #'equal)

(after! helpful
  (defun my/org-help-link-make-nicer ()
    "Add an :insert-description property to \"help\" links in Org that
uses the symbol name as the default description, as well as a
:complete property to create links with completion."
    (org-link-set-parameters
     "help"
     :insert-description (lambda (url desc)
                           (or desc
                               (substring url 5)))
     :complete (lambda (&optional arg)
                 (concat "help:"
                         (symbol-name (helpful--read-symbol
                                       "Symbol: "
                                       (helpful--symbol-at-point)
                                       #'always))))))
  (advice-add #'helpful--add-support-for-org-links
              :after #'my/org-help-link-make-nicer))

(after! helpful
  (advice-add 'helpful-update
              :after #'elisp-demos-advice-helpful-update))

(envrc-global-mode)

(defun my/direnv-use-nix (arg)
  "Create an .envrc file with \"use nix\" as content and enable
direnv. With prefix argument ARG, use \"use flake\" as content
instead."
  (interactive "P")
  (let* ((dir (if-let ((proj (project-current)))
                  (project-root proj)
                default-directory))
         (path (expand-file-name ".envrc" dir)))
    (with-temp-file path
      (insert (if arg
                  "use flake"
                "use nix")))
    (envrc-allow)))

(bind-keys :map my/git-map
           ("b" . magit-branch)
           ("B" . magit-blame)
           ("c" . magit-commit)
           ("C" . magit-clone)
           ("g" . magit-status)
           :map project-prefix-map
           ("m" . magit-project-status))

(after! project
  (setf (alist-get 'magit-project-status project-switch-commands)
        '("Magit")))

(after! magit
  (setopt magit-save-repository-buffers 'dontask
          magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1
          magit-bind-magit-project-status nil ;; We do this ourselves for lazy-loading
          magit-clone-default-directory "~/git/"))

(defvar-keymap my/magit-navigation-repeat-map
  :repeat t
  "n" #'magit-next-line
  "p" #'magit-previous-line)

(after! magit
  (add-to-list 'magit-clone-name-alist 
               `("\\`\\(?:gh-skissue:\\)?\\([^:]+\\)\\'" "gh-skissue" "skissue"))
  (add-to-list 'magit-clone-name-alist 
               `("\\`\\(?:cb-skissue:\\)?\\([^:]+\\)\\'" "cb-skissue" "skissue"))
  (add-to-list 'magit-clone-name-alist 
               `("\\`\\(?:work:\\)?\\([^:]+\\)\\'" "gh-work" ,(my/private '(user work)))))

(bind-key "t" #'git-timemachine my/git-map)

(autoload-many "diff-hl" nil #'diff-hl-magit-pre-refresh #'diff-hl-magit-post-refresh)
(add-hooks (find-file-hook          . diff-hl--global-turn-on)
           (magit-pre-refresh-hook  . diff-hl-magit-pre-refresh)
           (magit-post-refresh-hook . diff-hl-magit-post-refresh))

(after! magit
  (require 'forge))

(after! forge
  (dolist (host '("gh-skissue" "gh-work"))
    (setf (alist-get host forge-alist
                     nil nil #'equal)
          '("api.github.com" "github.com" forge-github-repository))))

(add-hooks (text-mode-hook . yas-minor-mode)
           (prog-mode-hook . yas-minor-mode))
(after! yasnippet
  (defun my/corfu-active-p ()
    (and (frame-live-p corfu--frame) (frame-visible-p corfu--frame)))
  (cl-pushnew #'my/corfu-active-p yas-keymap-disable-hook))

(after! yasnippet
  (require 'yasnippet-snippets))

(cl-pushnew "@doom_snippets_src@" load-path
            :test #'equal)
(after! yasnippet
  (require 'doom-snippets))

(after! doom-snippets
  (setopt yas-snippet-dirs `(,(expand-file-name "snippets/"
                                                user-emacs-directory)
                             doom-snippets-dir
                             yasnippet-snippets-dir)))

(idle-load 'pulsar)
(after! pulsar
  (setopt pulsar-face 'highlight
          pulsar-delay 0.04
          pulsar-iterations 8)
  (dolist (f '(my/smooth-scroll-up-command
               my/smooth-scroll-down-command
               org-edit-special))
    (cl-pushnew f pulsar-pulse-functions))
  (pulsar-global-mode))

(autoload #'copilot-mode "copilot" "Minor mode for Copilot." t)
(bind-key "c" #'copilot-mode my/toggle-map)

(after! copilot
  (bind-keys :map copilot-completion-map
             ("M-RET"   . copilot-accept-completion)
             ("M-n"     . copilot-next-completion)
             ("M-p"     . copilot-previous-completion)
             ("M-<tab>" . copilot-accept-completion-by-line)
             ("M-f"     . copilot-accept-completion-by-word)))

(setf (alist-get "\\.pdf\\'" auto-mode-alist
                 nil nil #'equal)
      #'pdf-tools-install
      (alist-get "%PDF" magic-mode-alist
                 nil nil #'equal)
      #'pdf-tools-install)

(after! dirvish
  (add-hook 'dirvish-directory-view-mode-hook #'pdf-tools-install))

(after! pdf-tools
  (bind-key "?" #'gptel-quick pdf-view-mode-map))

(defvar-keymap my/pdf-view-repeat-map
  :repeat t
  "n" #'pdf-view-next-line-or-next-page
  "p" #'pdf-view-previous-line-or-previous-page)

(defun my/zoxide-add-safe (&optional path &rest _)
  "Call `zoxide-add' if PATH exists."
  (require 'zoxide)
  (unless path
    (setq path (funcall zoxide-get-path-function 'add)))
  (when (file-exists-p path)
    (zoxide-add path)))

(add-hooks (find-file-hook . my/zoxide-add-safe)
           (eshell-directory-change-hook . my/zoxide-add-safe)
           (dirvish-find-entry-hook . my/zoxide-add-safe))

(bind-key "f" #'focus-mode my/toggle-map)

(add-hook 'prog-mode-hook #'hl-todo-mode)

(after! hl-todo
  (setopt hl-todo-keyword-faces
          `(("TODO" . ,(catppuccin-get-color 'green))
            ("FIXME" . ,(catppuccin-get-color 'yellow))
            ("HACK" . ,(catppuccin-get-color 'blue)))))

(bind-keys :map goto-map
           ("t" . consult-todo)
           ("T" . consult-todo-all))

(after! xref
  (setopt xref-search-program 'ripgrep
          xref-truncation-width nil))

(add-hooks (prog-mode-hook          . topsy-mode)
           (magit-section-mode-hook . topsy-mode))

(bind-key "w" #'writeroom-mode my/toggle-map)

(after! writeroom-mode
  (setopt writeroom-maximize-window nil
          writeroom-fullscreen-effect 'maximized))

(add-hook 'text-mode-hook #'jinx-mode)
(bind-key [remap ispell-word] #'jinx-correct)

(after! ispell
  (setopt ispell-alternate-dictionary (getenv "WORDLIST")))

(apheleia-global-mode)

(cl-defun my/apheleia-format-with-eglot
    (&key buffer scratch callback &allow-other-keys)
  "Copy BUFFER to SCRATCH, then format scratch, then call CALLBACK."
  (if (not (and (featurep 'eglot)
                (with-current-buffer buffer
                  (eglot-current-server))))
      (funcall callback '(error . "Eglot not available"))
    (with-current-buffer scratch
      (setq-local eglot--cached-server
                  (with-current-buffer buffer
                    (eglot-current-server)))
      (let ((buffer-file-name (buffer-local-value 'buffer-file-name buffer)))
        (eglot-format-buffer))
      (funcall callback))))

(after! apheleia
  (setf (alist-get 'eglot apheleia-formatters)
        #'my/apheleia-format-with-eglot)
  (dolist (mode '(rustic-mode
                  nix-ts-mode))
    (setf (alist-get mode apheleia-mode-alist)
          'eglot)))

(bind-key "C-x u" #'vundo)

(undo-fu-session-global-mode)

(setopt undo-fu-session-compression 'zst
        undo-fu-session-file-limit 100)

(bind-key "C-c A" #'gptel-send)

(autoload #'gptel-context-add "gptel-context" "Add context to gptel in a DWIM fashion.

- If a region is selected, add the selected region to the
  context.  If there is already a gptel context at point, remove it
  instead.

- If in Dired, add marked files or file at point to the context.
  With negative prefix ARG, remove them from the context instead.

- Otherwise add the current buffer to the context.  With positive
  prefix ARG, prompt for a buffer name and add it to the context.

- With negative prefix ARG, remove all gptel contexts from the
  current buffer." t)

(after! embark
  (bind-key "C" #'gptel-context-add embark-general-map))

(after! gptel
  (setopt gptel-model "llama3.1:latest"
          gptel-backend (gptel-make-ollama "Ollama"
                          :host "windstorm:11434"
                          :stream t
                          :models '("llama3.1:latest" "mistral:latest" "gemma2:latest"))
          gptel-default-mode #'org-mode
          gptel-use-context 'user))

(autoload #'gptel-quick "gptel-quick" "Explain or summarize region or thing at point with an LLM.

QUERY-TEXT is the text being explained.  COUNT is the approximate
word count of the response." t)

(after! embark
  (bind-key "?" #'gptel-quick embark-general-map))

(autoload #'treesit-fold-indicators-mode "treesit-fold-indicators" "Minor mode for display fringe folding indicators." t)

(add-hook 'prog-mode-hook #'treesit-fold-indicators-mode)

(after! treesit-fold
  (bind-keys :map prog-mode-map
             ("C-c C-f c" . treesit-fold-close)
             ("C-c C-f C" . treesit-fold-close-all)
             ("C-c C-f o" . treesit-fold-open)
             ("C-c C-f O" . treesit-fold-open-all)
             ("C-c C-f r" . treesit-fold-open-recursively)
             ("C-c C-f z" . treesit-fold-toggle)))

(cl-pushnew "@consult_mu_src@" load-path
            :test #'equal)

(cl-pushnew "@consult_omni_src@" load-path
            :test #'equal)
(cl-pushnew "@consult_omni_src@/sources" load-path
            :test #'equal)

(autoload #'consult-omni "consult-omni" "Convinient wrapper function for favorite interactive command.

Calls the function in `consult-omni-default-interactive-command'." t)

(bind-key "C-S-s" #'consult-omni)

(after! consult-omni
  ;; For some reason, if `mu4e' doesn't load properly, `consult-omni-mu4e'
  ;; causes it to crash and burn.
  (require 'mu4e)
  (require 'consult-omni-sources)
  (require 'consult-omni-embark)

  (setopt consult-omni-sources-modules-to-load '(consult-omni-wikipedia
                                                 consult-omni-gptel
                                                 consult-omni-calc
                                                 consult-omni-buffer
                                                 consult-omni-mu4e
                                                 consult-omni-stackoverflow
                                                 consult-omni-dict
                                                 consult-omni-man
                                                 consult-omni-org-agenda
                                                 consult-omni-notes))
  (consult-omni-sources-load-modules)

  (setopt consult-omni-http-retrieve-backend 'plz
          consult-omni-multi-sources '("Wikipedia"
                                       "gptel"
                                       "calc"
                                       "Buffer"
                                       "File"
                                       "mu4e"
                                       "StackOverflow"
                                       "Dictionary"
                                       "man"
                                       "Org Agenda"
                                       "Notes Search")
          consult-omni-notes-files (list denote-directory)
          consult-omni-notes-backend-command "rga"
          consult-omni--notes-new-func #'consult-omni--notes-new-create-denote))

(bind-keys ("C-=" . expreg-expand)
           ("C-+" . expreg-contract))

(defvar-keymap my/expreg-repeat-map
  :repeat t
  "=" #'expreg-expand
  "+" #'expreg-contract)

(defun my/denote-ingest-file (arg)
  "Rename a file using `denote-rename-file', then move it into
`denote-directory'. With prefix argument ARG, copy the file instead of moving
it."
  (interactive "P")
  (let* ((fn (if arg #'copy-file #'rename-file))
         (filename (expand-file-name (read-file-name "Ingest File: ")))
         (basename (file-name-nondirectory filename))
         (target (expand-file-name basename (denote-directory))))
    (funcall fn filename target)
    (apply #'denote-rename-file target
           (denote--rename-get-file-info-from-prompts-or-existing target))))

(bind-keys :map my/notes-map
           ("b" . denote-backlinks)
           ("f" . denote-open-or-create)
           ("I" . my/denote-ingest-file)
           ("l" . denote-link-or-create)
           ("L" . denote-org-extras-link-to-heading)
           ("k" . denote-rename-file-keywords))
(bind-key "C-c X" #'org-capture)

(add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)

(setopt denote-directory "~/denote/")

(after! denote
  (denote-rename-buffer-mode)
  (consult-denote-mode)
  ;; Illegal characters on Android
  (setopt denote-excluded-punctuation-extra-regexp (rx (* (or "<" ">")))
          denote-excluded-directories-regexp "publish/"
          denote-known-keywords '("quest" "person" "needy" "private"
                                  "reference" "thought" "journal")
          denote-date-prompt-use-org-read-date t
          denote-backlinks-show-context t
          denote-prompts '(title date keywords template)
          denote-dired-directories (list denote-directory)
          denote-dired-directories-include-subdirectories t
          denote-templates `((default . "")
                             (person . ,(lambda ()
                                          (with-temp-buffer
                                            (insert-file-contents
                                             (expand-file-name
                                              "template/person.org"
                                               denote-directory))
                                            (buffer-string)))))
          consult-denote-grep-command #'consult-ripgrep))

(after! org-capture
  (require 'denote))

(defun my/goto-thought-stack ()
  "Visit Denote thought stack file. Used by `org-capture' template."
  (let ((path (car
               (seq-filter (lambda (x)
                             (string-match-p "--thought-stack" x))
                           (denote-directory-files)))))
    (find-file path)
    (goto-char (point-min))))

(after! org-capture
  (cl-pushnew '("t" "Push note onto thought stack" entry
                (function my/goto-thought-stack)
                "* [%<%F %a %R>] %?"
                :prepend t
                :empty-lines 1
                :kill-buffer t)
              org-capture-templates
              :test #'equal))

(defun my/denote-journal-yesterday (&optional forward)
  "Visit or create yesterday's Denote journal entry.
If FORWARD is non-nil, go to tomorrow instead."
  (interactive)
  (denote-journal-extras-new-or-existing-entry
   (time-add nil (* 60 60 24 (if forward 1 -1)))))

(defun my/denote-journal-tomorrow ()
  "Visit or create tomorrow's Denote journal entry."
  (interactive)
  (my/denote-journal-yesterday :forward))

(bind-keys :map my/notes-map
           :prefix "d"
           :prefix-map my/denote-journal-map
           ("d" . denote-journal-extras-new-or-existing-entry)
           ("l" . denote-journal-extras-link-or-create-entry)
           ("t" . my/denote-journal-tomorrow)
           ("y" . my/denote-journal-yesterday))

(defun my/denote-journal-prepare-check-in ()
  "Function called by `org-capture' to prepare for a check-in entry
capture. Visits the journal entry for today and moves point to
the end of the file."
  (denote-journal-extras-new-or-existing-entry)
  (goto-char (point-max)))

(after! org-capture
  (cl-pushnew '("d" "Check-in entry in today's journal" plain
                (function my/denote-journal-prepare-check-in)
                "+ =%<%H:%M>=: %?"
                :kill-buffer t
                :clock-in t
                :clock-resume t)
              org-capture-templates
              :test #'equal))

(after! denote-journal-extras
  (setopt denote-journal-extras-directory (expand-file-name "journal/" denote-directory)
          denote-journal-extras-title-format "%Y-%m-%d %a")
  (setf (alist-get 'journal denote-templates)
        (lambda ()
          (with-temp-buffer
            (insert-file-contents
             (expand-file-name "template/journal.org"
                               ;; We have to use `default-toplevel-value' here
                               ;; because the journal code let-binds
                               ;; `denote-directory' to the journal
                               ;; subdirectory.
                               (default-toplevel-value 'denote-directory))) 
            (buffer-string)))))

(bind-keys :map my/notes-map
           :prefix "e"
           :prefix-map my/denote-explore-map
           ("cd" . denote-explore-degree-barchart)
           ("ce" . denote-explore-extensions-barchart)
           ("ck" . denote-explore-keywords-barchart)
           ("d"  . denote-explore-identify-duplicate-notes)
           ("i"  . denote-explore-isolated-notes)
           ("n"  . denote-explore-network)
           ("N"  . denote-explore-network-regenerate)
           ("rk" . denote-explore-random-keyword)
           ("rl" . denote-explore-random-link)
           ("rn" . denote-explore-random-note)
           ("s"  . denote-explore-sync-metadata))

(defun my/fix-denote-heading-links-in-capture (fn &rest args)
  "Around advice for `org-capture' that binds
`denote-org-store-link-to-heading' to 'nil', to avoid randomly
creating 'CUSTOM_ID' properties, since `org-capture' uses the
Org linking mechanism internally."
  (let ((denote-org-store-link-to-heading nil))
    (apply fn args)))

(after! org-capture
  (advice-add #'org-capture :around #'my/fix-denote-heading-links-in-capture))

(defun my/denote-link-description (file)
  "Format a link description for FILE.

- If the region is active, use the region.

- If FILE is not a supported text file, use the name of the file.

- Otherwise, prompts for a description, sourcing from:
`denote-link-description-with-signature-and-title' and aliases if they are
present. Auto-picks if only one option is available."
  (cond
   ((region-active-p)
    (buffer-substring-no-properties (region-beginning) (region-end)))
   ((not (denote-file-has-supported-extension-p file))
    (file-name-nondirectory file))
   (t
    (let ((options (list (denote-link-description-with-signature-and-title file)))
          (file-type (denote-filetype-heuristics file)))
      (when (eq file-type 'org)
        (with-temp-buffer
          (insert-file-contents file)
          (org-mode)
          (when-let* ((prop (cdar (org-collect-keywords '("aliases") '("aliases"))))
                      (aliases (split-string-and-unquote prop)))
            (nconc options aliases))))
      (if (cdr options)
          (completing-read "Description: " options)
        (car options))))))

(after! denote
  (setopt denote-link-description-function #'my/denote-link-description))

(autoload #'denote-file-is-note-p "denote" "Return non-nil if FILE is an actual Denote note.
For our purposes, a note must not be a directory, must satisfy
`file-regular-p' and `denote-filename-is-note-p'.")
(defun my/enable-gac-in-denote ()
  "Enable `git-auto-commit-mode' if the visited file is a Denote file."
  (when (and buffer-file-name
             (denote-file-is-note-p buffer-file-name))
    (git-auto-commit-mode)))

(add-hook 'find-file-hook #'my/enable-gac-in-denote)

(after! git-auto-commit-mode
  (setopt gac-silent-message-p t
          gac-debounce-interval 60))

(after! citar
  (citar-denote-mode)
  (setopt citar-bibliography (list
                              (expand-file-name "refs.bib" denote-directory))
          org-cite-global-bibliography citar-bibliography))

(add-hook 'org-mode-hook #'variable-pitch-mode)
(add-hook 'org-mode-hook #'writeroom-mode)
(add-hook 'org-mode-hook (lambda () (setq-local line-spacing 0.1)))
(add-hook 'org-mode-hook #'org-autolist-mode)

(after! org
  (setopt org-directory                          denote-directory
          org-hide-emphasis-markers              t
          org-confirm-babel-evaluate             nil
          org-startup-indented                   t
          org-indent-indentation-per-level       0
          org-startup-folded                     'content
          org-ellipsis                           " "
          org-pretty-entities                    t
          org-log-done                           'note
          org-log-into-drawer                    t
          org-log-reschedule                     'note
          org-log-redeadline                     'note
          org-return-follows-link                t
          org-attach-method                      'mv
          org-use-sub-superscripts               '{}
          org-list-demote-modify-bullet          '(("+" . "-")
                                                   ("-" . "*")
                                                   ("*" . "+"))
          org-highlight-latex-and-related        '(native script entities)
          org-preview-latex-image-directory      (expand-file-name
                                                  "org/latex/"
                                                  no-littering-var-directory)
          org-insert-heading-respect-content     t
          org-auto-align-tags                    nil
          org-tags-column                        0
          org-special-ctrl-a/e                   t
          org-todo-keywords                      '((type "TODO(t)"
                                                         "WAIT(w@/@)"
                                                         "|"
                                                         "DONE(d)"
                                                         "CANCELED(c)"))
          org-fontify-done-headline              t
          org-fontify-quote-and-verse-blocks     t
          org-startup-with-inline-images         t
          org-image-actual-width                 nil
          org-enforce-todo-dependencies          t
          org-list-allow-alphabetical            t
          org-edit-src-auto-save-idle-delay      5
          org-todo-keyword-faces `(("CANCELED"
                                    :foreground ,(catppuccin-get-color 'red))
                                   ("WAIT"
                                    :foreground ,(catppuccin-get-color 'yellow))))
  (custom-set-faces
   `(org-headline-done ((t :inherit nil
                           :italic t
                           :strike-through t)))))

(defvar-keymap my/org-sentence-repeat-map
  :repeat t
  "e" #'org-forward-sentence
  "a" #'org-backward-sentence)

(defvar-keymap my/org-line-repeat-map
  :repeat t
  "a" #'org-beginning-of-line
  "e" #'org-end-of-line)

(defvar-keymap my/org-element-repeat-map
  :repeat t
  "}" #'org-forward-element
  "{" #'org-backward-element)

(defvar-keymap my/org-delete-repeat-map
  :repeat t
  "d" #'org-delete-char)

(defvar-keymap my/org-heading-repeat-map
  :repeat t
  "n" #'org-next-visible-heading
  "p" #'org-previous-visible-heading)

(defvar-keymap my/org-link-repeat-map
  :repeat t
  "n" #'org-next-link
  "p" #'org-previous-link)

(defvar-keymap my/org-block-repeat-map
  :repeat t
  "f" #'org-next-block
  "b" #'org-previous-block)

(bind-key "C-c a" #'org-agenda)

(after! org-agenda
  (defun my/org-agenda-get-title ()
    "Get the title of the current Org buffer, or else an empty string."
    (if-let* ((title (org-get-title))
              (title (if (length> title 26)
                         (concat (string-limit title 25)
                                 "…")
                       title)))
        (format "%s: " title)
      ""))

  (setopt org-agenda-files (list denote-directory)
          org-agenda-file-regexp (rx "_quest" (* any) ".org" string-end)
          org-agenda-prefix-format '((agenda . " %i%-28(my/org-agenda-get-title)% t%s%b")
                                     (todo   . " %i%-28(my/org-agenda-get-title)%b")
                                     (tags   . " %i %-12:c")
                                     (search . " %i %-12:c"))
          org-agenda-time-leading-zero t
          org-agenda-time-grid '((daily today remove-match)
                                 (600 800 1000 1200 1400 1600 1800 2000 2200)
                                 " ┄┄┄┄┄" "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
          org-agenda-current-time-string "—————————————————— now"
          org-agenda-breadcrumbs-separator " ⇢ "
          org-agenda-tags-column 0
          org-agenda-skip-deadline-if-done t
          org-agenda-skip-scheduled-if-done t
          org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled
          org-agenda-hide-tags-regexp (rx (or "quest" "journal" "needy"))
          org-agenda-span 'fortnight
          org-agenda-start-on-weekday nil
          org-agenda-start-day "-3d"
          org-agenda-window-setup 'current-window
          org-agenda-inhibit-startup t
          org-agenda-compact-blocks t
          org-agenda-deadline-leaders '("Deadline: "
                                        "In %3dd: "
                                        "%2dd ago: ")
          org-agenda-deadline-faces '((0.8 . org-imminent-deadline)
                                      (0.5 . org-upcoming-deadline)
                                      (0.0 . org-upcoming-distant-deadline)))
  (custom-set-faces
   `(org-imminent-deadline         ((t (:foreground ,(catppuccin-get-color 'red) :weight semibold))))
   `(org-upcoming-deadline         ((t (:foreground ,(catppuccin-get-color 'yellow) :weight medium))))
   `(org-upcoming-distant-deadline ((t (:foreground ,(catppuccin-get-color 'yellow) :weight light))))))

(add-hook 'org-agenda-mode-hook (lambda ()
                                  (face-remap-add-relative 'default 'fixed-pitch)))

(after! org
  (require 'org-habit)
  (setopt org-habit-preceding-days 14
          org-habit-following-days 7
          org-habit-graph-column 100))

(after! org-agenda
  (require 'denote-journal-extras)
  (org-super-agenda-mode)

  (defun my/agenda-transform-daily-plan-line (line)
    "Specially format a \"Daily Plan\" line for my custom agenda view."
    (save-match-data
      (if (string-match (rx
                         (group (= 2 digit) ":" (= 2 digit))
                         (group (or "-" " "))
                         (group (or (seq (= 2 digit) ":" (= 2 digit))
                                    "┄┄┄┄┄"))
                         " Daily Plan ⇢ "
                         (group (* any))
                         string-end)
                        line)
          (apply #'propertize
                 (format " %s                 %s%s%s %s"
                         (propertize "Daily Plan:"
                                     'face 'org-agenda-calendar-event)
                         (match-string 1 line)
                         (match-string 2 line)
                         (match-string 3 line)
                         (match-string 4 line))
                 (text-properties-at 0 line))
        line)))
  
  (setopt
   org-super-agenda-unmatched-name "Other"
   org-agenda-custom-commands
   '(("c" "Custom super view"
      ((agenda "" ((org-agenda-files
                     (append org-agenda-files
                             (denote-journal-extras--entry-today)))
                   (org-agenda-span 'day)
                   (org-agenda-start-day nil)
                   (org-super-agenda-groups
                    '((:habit t
                              :order 1)
                      (:name "Today"
                             :time-grid t
                             :date today
                             :transformer my/agenda-transform-daily-plan-line)
                      (:name "Overdue"
                             :deadline past
                             :scheduled past
                             :order 2)
                      (:name "Due Soon"
                             :deadline future
                             :order 3)))))
       (alltodo "" ((org-agenda-overriding-header "")
                    (org-super-agenda-groups
                     '((:discard (:habit t))
                       (:name "Important"
                              :priority "A")
                       (:name "Upcoming"
                              :scheduled future)
                       (:name "Academics"
                              :tag "academics")
                       (:name "Programming"
                              :tag "programming"))))))))))

(bind-key "s" #'org-store-link my/notes-map)

(bind-keys :map my/notes-map
           ("cg" . org-clock-goto)
           ("ci" . org-clock-in)
           ("cl" . org-clock-in-last)
           ("co" . org-clock-out)
           ("cq" . org-clock-cancel)
           ("cr" . org-resolve-clocks))

(after! org-src
  (bind-key "C-c C-c" #'org-edit-src-exit org-src-mode-map))

(after! org-attach
  (setopt org-attach-id-dir "attach")
  (defun my/insert-org-attach-dir ()
    "Insert the current org-attach directory relative to
 `org-directory', creating it if needed."
    (interactive)
    (insert
     (file-relative-name (org-attach-dir-get-create)
                         org-directory))))

(after! org
  (global-org-modern-mode))

(after! org-modern
  (setopt org-modern-list '((?+ . "➤")
                            (?- . "–")
                            (?* . "•"))
          org-modern-progress 8
   ;; For some reason, inheriting from `org-modern-todo' messes with the size
          org-modern-todo-faces `(("CANCELED"
                                   :inverse-video t
                                   :weight semibold
                                   :foreground ,(catppuccin-get-color 'red))
                                  ("WAIT"
                                   :inverse-video t
                                   :weight semibold
                                   :foreground ,(catppuccin-get-color 'yellow)))))

(custom-set-faces
 `(org-modern-done ((t :inherit org-modern-todo
                       :foreground ,(catppuccin-get-color 'green)))) 
 '(org-modern-symbol ((t (:family "Iosevka Fixed SS18")))))

(add-hook 'org-mode-hook #'org-appear-mode)

(after! org-appear
  (setopt org-appear-trigger        'always
          org-appear-autosubmarkers t
          org-appear-autoentities   t))

(add-hook 'org-mode-hook #'org-fragtog-mode)

(after! org-download
  (setopt org-download-backend "curl \"%s\" -o \"%s\""
          org-download-delete-image-after-download t
          org-download-method 'attach
          org-download-screenshot-method "grim -g \"$(slurp)\" %s"))

(after! org-anki
  (setopt org-anki-default-deck "Default"))

(add-hook 'org-mode-hook #'org-auto-tangle-mode)

(add-hook 'org-mode-hook #'org-make-toc-mode)

(after! ox
  (setopt org-export-with-toc nil))

(after! (ox ob)
  (setf (alist-get :eval org-babel-default-header-args)
        "no-export"
        (alist-get :exports org-babel-default-header-args)
        "both"))

(after! ox
  (require 'org-re-reveal)
  (setopt org-re-reveal-root (expand-file-name "revealjs"
                                               (getenv "XDG_DATA_HOME"))
          org-re-reveal-extra-options "controlsTutorial: false"))

(autoload #'org-babel-execute:C "ob-C" "Execute a block of C code with org-babel.
This function is called by `org-babel-execute-src-block'." nil)
(autoload #'org-babel-execute:C++ "ob-C" "Execute a block of C++ code with org-babel.
This function is called by `org-babel-execute-src-block'." nil)
(autoload #'org-babel-execute:cpp "ob-C" "Execute BODY according to PARAMS.
This function calls `org-babel-execute:C++'." nil)

(after! ob-C
  (setopt org-babel-C-compiler "cc"
          org-babel-C++-compiler "c++"))

(autoload #'org-babel-execute:sh "ob-shell" "Execute a block of sh commands with Babel." nil)
(autoload #'org-babel-execute:shell "ob-shell" "Execute a block of Shell commands with Babel." nil)
(autoload #'org-babel-execute:bash "ob-shell" "Execute a block of bash commands with Babel." nil)

(autoload #'org-babel-execute:gnuplot "ob-gnuplot" "Execute a block of Gnuplot code.
This function is called by `org-babel-execute-src-block'." nil)

(autoload #'org-babel-execute:typst "org-typst" "Execute a block of Typst markup." nil)

(after! org-typst
  (cl-pushnew "#import \"@preview/cetz:0.2.2\""
              org-typst-babel-preamble
              :test #'equal))

(autoload #'org-babel-execute:lisp "ob-lisp" "Execute a block of Common Lisp code with Babel.
BODY is the contents of the block, as a string.  PARAMS is
a property list containing the parameters of the block.")

(after! ob-lisp
  (setopt org-babel-lisp-eval-fn #'sly-eval))

(autoload #'org-babel-execute:d2 "ob-d2" "Execute a BODY of D2 code with org-babel and additional PARAMS.
This function is called by `org-babel-execute-src-block'.")

(defface my/org-list-bullet
  '((t :inherit (fixed-pitch org-list-dt)))
  "Custom face for Org list bulletpoints.")
  
(defun my/org-list-bullet-font-lock-setup ()
  "Set up `org-font-lock-extra-keywords' to use my custom bullet face."
  (push '("^\\( *\\)\\([-+]\\|\\(?:[0-9]+\\|[a-zA-Z]\\)[).]\\)\\([ \t]\\)"
          (1 'org-indent append)
          (2 'my/org-list-bullet append)
          (3 'org-indent append))
        org-font-lock-extra-keywords)
  (push '("^\\( +\\)\\(\\*\\|\\(?:[0-9]+\\|[a-zA-Z]\\)[).]\\)\\([ \t]\\)"
          (1 'org-indent append)
          (2 'my/org-list-bullet append)
          (3 'org-indent append))
        org-font-lock-extra-keywords))

(add-hook 'org-font-lock-set-keywords-hook #'my/org-list-bullet-font-lock-setup)

(after! org
  (defun my/org-inline-images-fix-svg-colors (image)
    "If IMAGE is an SVG, explicitly set the foreground and
 background colors to white and black, respectively. Fixes
 legibility of most generated SVGs."
    (if-let* ((props (cdr image))
              (type (plist-get props :type))
              ((not (eq type 'svg))))
        image
      `(,@image :foreground "#000000" :background "#FFFFFF")))
  (advice-add #'org--create-inline-image :filter-return #'my/org-inline-images-fix-svg-colors))

(after! org
  (advice-add #'org-remove-inline-images :override #'org-sliced-images-remove-inline-images)
  (advice-add #'org-toggle-inline-images :override #'org-sliced-images-toggle-inline-images)
  (advice-add #'org-display-inline-images :override #'org-sliced-images-display-inline-images))

(autoload #'org-popup-posframe-mode "org-popup-posframe" "Show `org-mode' popup buffers in posframe." t)

(after! org
  (setopt org-popup-posframe-org-insert-link nil
          ;; Currently broken with Org 9.7
          org-popup-posframe-org-todo nil)
  (org-popup-posframe-mode))

(add-hook 'lisp-data-mode-hook #'parinfer-rust-mode)
(add-hook 'parinfer-rust-mode-hook (lambda () (electric-pair-local-mode -1)))

(after! parinfer-rust-mode
  (setopt parinfer-rust-auto-download t
          parinfer-rust-troublesome-modes nil))

(add-hook 'emacs-lisp-mode-hook #'package-lint-flymake-setup)
(add-hook 'emacs-lisp-mode-hook #'display-fill-column-indicator-mode)

(add-hook 'sly-mode-hook #'corfu-mode)

(after! sly
  (setopt inferior-lisp-program "sbcl"))

(setf (alist-get "\\.nix\\'" auto-mode-alist
                 nil nil #'equal)
      #'nix-ts-mode)

(add-hook 'nix-ts-mode-hook (lambda ()
                              (yas-activate-extra-mode 'nix-mode)))

(after! (nix-ts-mode eglot)
  (setf (alist-get 'nix-ts-mode eglot-server-programs)
        '("nil" :initializationOptions
          (:formatting (:command ["alejandra"])))))

(after! org
  (setf (alist-get "nix" org-src-lang-modes
                   nil nil #'equal)
        'nix-ts))

(setf (alist-get "\\.rs\\'" auto-mode-alist
                 nil nil #'equal)
      #'rustic-mode)

(setopt rust-mode-treesitter-derive t)

(after! rustic
  (setopt rustic-lsp-client 'eglot))

(autoload #'typst-ts-mode "typst-ts-mode" "Major mode for editing Typst, powered by tree-sitter." t)
(setf (alist-get "\\.typ\\'" auto-mode-alist
                 nil nil #'equal)
      #'typst-ts-mode)
(add-hook 'typst-ts-mode-hook #'writeroom-mode)
(add-hook 'typst-ts-mode-hook #'hl-todo-mode)

(after! org
  (setf (alist-get "typst" org-src-lang-modes
                   nil nil #'equal)
        'typst-ts))
(after! typst-ts-mode
  (setopt typst-ts-mode-indent-offset 2))
(after! (typst-ts-mode eglot)
  (setf (alist-get 'typst-ts-mode eglot-server-programs)
        '("tinymist" :initializationOptions
          (:formatterMode "typstyle"))))

(setf (alist-get "\\.nu\\'" auto-mode-alist
                 nil nil #'equal)
      #'nushell-mode
      (alist-get "nu" interpreter-mode-alist
                 nil nil #'equal)
      #'nushell-mode)

(setf (alist-get "[Jj]ustfile\\'" auto-mode-alist
                 nil nil #'equal)
      #'just-mode)

(bind-key "j" #'justl project-prefix-map)

(after! project
  (defun my/justl-project ()
    "Wrapper around `justl' that uses
 `project-current-directory-override'."
    (interactive)
    (let ((default-directory project-current-directory-override))
      (call-interactively #'justl)))
  (setf (alist-get 'my/justl-project project-switch-commands)
        '("Just" "j")))

(setf (alist-get "\\.gp\\'" auto-mode-alist
                 nil nil #'equal)
      #'gnuplot-mode)

(setf (alist-get "\\.ya?ml\\'" auto-mode-alist
                 nil nil #'equal)
      #'yaml-ts-mode)

(after! org
  (setf (alist-get "yaml" org-src-lang-modes
                   nil nil #'equal)
        'yaml-ts))

(setf (alist-get "\\.m\\'" auto-mode-alist
                 nil nil #'equal)
      #'octave-mode)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))

(add-hook 'sgml-mode-hook #'emmet-mode)
(add-hook 'web-mode-hook #'emmet-mode)

(after! bibtex
  (setopt bibtex-maintain-sorted-entries 'entry-class
          bibtex-entry-format t))

(bind-key "m" #'osm my/open-map)

(add-hook 'osm-mode-hook (lambda ()
                           (visual-line-mode -1)
                           (setq-local truncate-lines t)))

(setf (alist-get '(major-mode . osm-mode) display-buffer-alist
                 nil nil #'equal)
      '(display-buffer-same-window))

(after! (osm ol)
  (defun my/osm-publish-org-link (location description backend ext-plist)
    "Publish a geo: link as an OpenStreetMap URL."
    (cl-destructuring-bind (lat long z) (split-string location
                                                      (regexp-opt '("," ";z=")))
      (org-export-string-as
       (format "[[https://www.openstreetmap.org/#map=%s/%s/%s]%s]"
               z lat long
               (when description
                 (format "[%s]" description)))
       backend
       t
       ext-plist)))
  (org-link-set-parameters
   "geo"
   :export #'my/osm-publish-org-link))

(bind-key "d" #'dirvish my/open-map)

(after! dired
  (dirvish-override-dired-mode)
  (dired-async-mode)

  (setopt dired-dwim-target t))

(bind-key "s" #'syncthing my/open-map)

(after! syncthing
  (setopt syncthing-default-server-token "iPy5Nbp6JFhjPcECDTAvfxhuabgjjVQU"))

(bind-key "e" #'mu4e my/open-map)

(setopt mail-user-agent #'mu4e-user-agent
        read-mail-command #'mu4e)

(after! mu4e
  (bind-key "b" #'mu4e-search-bookmark mu4e-main-mode-map)
  
  (setopt send-mail-function #'sendmail-send-it
          message-confirm-send t
          message-signature 'user-full-name
          mail-specify-envelope-from t
          mail-envelope-from 'header
          message-kill-buffer-on-exit t
          mu4e-get-mail-command "mbsync -a"
          mu4e-change-filenames-when-moving t
          mu4e-refile-folder "/archive"
          mu4e-use-fancy-chars t
          mu4e-read-option-use-builtin nil
          mu4e-completing-read-function #'completing-read
          mu4e-compose-format-flowed t
          mu4e-confirm-quit nil
          mu4e-search-hide-predicate (lambda (msg)
                                       (member 'trashed
                                               (mu4e-message-field msg :flags)))
          mu4e-context-policy 'pick-first
          mu4e-contexts
          `(,(make-mu4e-context
              :name (my/private '(user public))
              :match-func
              (lambda (msg)
                (and msg
                     (cl-find-if
                      (lambda (email)
                        (string-match-p
                         (rx "@"
                             (literal (my/private '(domain public)))
                             string-end)
                         email))
                      (append (mu4e-message-field msg :to)
                              (mu4e-message-field msg :from))
                      :key (lambda (x) (plist-get x :email)))))
              :vars `((user-mail-address . ,(my/private '(email public)))
                      (user-full-name . "Ad")
                      (mu4e-sent-folder . "/mailbox/Sent")
                      (mu4e-drafts-folder . "/mailbox/Drafts")
                      (mu4e-trash-folder . "/mailbox/Trash")))
            ,(make-mu4e-context
              :name (my/private '(user personal))
              :match-func
              (lambda (msg)
                (and msg
                     (cl-find-if
                      (lambda (email)
                        (string-match-p
                         (rx "@"
                             (literal (my/private '(domain personal)))
                             string-end)
                         email))
                      (append (mu4e-message-field msg :to)
                              (mu4e-message-field msg :from))
                      :key (lambda (x) (plist-get x :email)))))
              :vars `((user-mail-address . ,(my/private '(email personal)))
                      (user-full-name . ,(my/private '(name)))
                      (mu4e-sent-folder . "/mailbox/Sent")
                      (mu4e-drafts-folder . "/mailbox/Drafts")
                      (mu4e-trash-folder . "/mailbox/Trash"))))))

(after! mu4e
  (defun my/mu4e-use-to-address ()
    "Use \"To\" address when replying with a catch-all alias."
    (when-let* ((msg mu4e-compose-parent-message)
                (parent-to (mu4e-message-field msg :to))
                (my-address (cl-find-if
                             (lambda (email)
                               (string-match-p
                                (rx "@"
                                    (or (literal (my/private '(domain public)))
                                        (literal (my/private '(domain personal))))
                                    string-end)
                                email))
                             parent-to
                             :key (lambda (x) (plist-get x :email))))
                (name (plist-get my-address :name))
                (email (plist-get my-address :email)))
      (message-replace-header "From"
                              (format "%s <%s>" name email))))
  (add-hook 'mu4e-compose-mode-hook #'my/mu4e-use-to-address))

(bind-key "s" #'eshell my/open-map)

(add-hook 'eshell-mode-hook #'corfu-mode)
(add-hook 'eshell-mode-hook #'electric-pair-local-mode)

(after! eshell
  (eat-eshell-mode)
  ;; Since we have Eat emulating a true terminal, we don't want any commands to
  ;; defer to an external `term' buffer.
  (setopt eshell-visual-commands nil)
  ;; Devil key
  (add-to-list 'eat-semi-char-non-bound-keys [?,])
  (add-to-list 'eat-eshell-semi-char-non-bound-keys [?,])
  (eat-update-semi-char-mode-map)
  (eat-eshell-update-semi-char-mode-map))

(after! em-hist
  (eshell-atuin-mode)
  (bind-keys ([remap eshell-list-history] . eshell-atuin-history)
             :map eshell-hist-mode-map
             ("M-r" . eshell-atuin-history)))

(defun my/eshell-nix-locate (command)
  "Locate possible executables for not found COMMAND using `nix-locate'."
  (let* ((cmd (format "nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root '/bin/%s'"
                      command))
         (matches (shell-command-to-string cmd)))
    (unless (string-empty-p matches)
      (error "The program `%s' is currently not installed. It is provided by the following derivations:\n%s"
             command matches))))

(add-hook 'eshell-alternate-command-hook #'my/eshell-nix-locate)

(defun eshell/z (&optional prompt)
  "Jump around directories using `consult-dir'."
  (if prompt
      (eshell/cd (or (eshell-find-previous-directory prompt)
                     (car (zoxide-query-with prompt))))
    (require 'consult-dir)
    (eshell/cd (consult-dir--pick))))

(defun my/eshell-prompt ()
  "My custom, prettier prompt for Eshell."
  (require 'magit)
  (concat "\n"
          (propertize (abbreviate-file-name (eshell/pwd))
                      'face 'eshell-ls-directory)
          (when (magit-gitdir (eshell/pwd))
            (concat " on "
                    (propertize (concat "" (magit-get-current-branch))
                                'face 'magit-branch-current)
                    (let (m u)
                      (cl-loop for (file _ x y) in (magit-file-status)
                               if (= y ??)
                               do (setq u "?")
                               else
                               do (setq m "!"))
                      (when (or m u)
                        (propertize (concat " [" m u "]")
                                    'face 'error)))))
          "\n"
          (propertize "λ " 'face (if (eshell-exit-success-p)
                                     'success
                                   'error))))

(after! eshell
  (setopt eshell-prompt-function #'my/eshell-prompt
          eshell-prompt-regexp (rx line-start "λ ")))

;; We highlight things we want highlighted ourselves
(custom-set-faces
 '(eshell-prompt ((t :foreground unspecified
                     :weight unspecified))))

(after! eshell
  (eshell-syntax-highlighting-global-mode))

(after! calc
  (bind-key "C-o" #'casual-calc-tmenu calc-mode-map))

(after! org
  ;; Can't use `bind-keys' because we need `verb-command-map' to be evaluated.
  (bind-key "C-c C-r" verb-command-map org-mode-map)
  ;; Originally bound to C-c C-r
  (bind-key "C-c C-S-r" #'org-fold-reveal org-mode-map))

(autoload #'org-babel-execute:verb "ob-verb")

(after! ob-verb
  (defvar org-babel-default-header-args:verb '((:wrap . "src ob-verb-response"))))

(after! spray
  (setopt spray-wpm 750
          spray-ramp 4)
  (custom-set-faces
   '(spray-accent-face ((t :inherit (error spray-base-face))))))

(autoload #'cfw:open-org-calendar "calfw-org" "Open an org schedule calendar in the new buffer." t)

(bind-key "c" #'cfw:open-org-calendar my/open-map)

(add-hook 'ement-room-compose-hook #'corfu-mode)

(after! ement
  (setopt ement-room-use-variable-pitch t
          ement-room-send-message-filter #'ement-room-send-org-filter))

(defun my/shruggie ()
  "Insert ¯\\_(ツ)_/¯."
  (interactive)
  (insert "¯\\_(ツ)_/¯"))
(bind-key "C-x 8 s" #'my/shruggie)

(defun my/sarcastic (start end)
  "Convert active region's casing to sArCaStIc."
  (interactive "r")
  (unless (use-region-p)
    (user-error "No region selected!"))
  (let* ((text (buffer-substring start end))
         (sarcastic-chars (cl-loop for c across text
                                   for i from 0
                                   if (zerop (mod i 2))
                                   collect (downcase c)
                                   else
                                   collect (upcase c)))
         (sarcastic (apply #'string sarcastic-chars)))
    (delete-region start end)
    (insert sarcastic)))

(defun my/screenshot-frame ()
  "Take a screenshot of the current frame and save it to the clipboard."
  (interactive)
  (with-temp-buffer
    (insert (x-export-frames nil 'png))
    (call-process-region nil nil "wl-copy")))

(defun my/toggle-frame-translucence ()
  "Toggle translucence for the current frame."
  (interactive)
  (set-frame-parameter
   nil 'alpha-background
   (if (= 0.85 (frame-parameter nil 'alpha-background))
       1.0
     0.85)))
         
(bind-key "t" #'my/toggle-frame-translucence my/toggle-map)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(add-hook 'nov-mode-hook #'visual-fill-column-mode)

(after! nov
  (setopt nov-text-width t
          visual-fill-column-center-text t))