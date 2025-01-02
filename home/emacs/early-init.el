(setq gc-cons-threshold most-positive-fixnum)

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
    (expand-file-name  "emacs/eln-cache/" (getenv "XDG_CACHE_HOME"))))

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq use-file-dialog nil
      use-dialog-box nil)

(push '(alpha-background . 0.85) default-frame-alist)

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      initial-buffer-choice nil
      inhibit-startup-buffer-menu t
      inhibit-x-resources t
      bidi-paragraph-direction 'left-to-right
      bidi-inhibit-bpa t
      initial-major-mode #'fundamental-mode
      initial-scratch-message nil
      frame-inhibit-implied-resize t
      auto-mode-case-fold nil)
