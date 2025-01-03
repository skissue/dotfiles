{
  config,
  lib,
  pkgs,
  inputs,
  private,
  sources,
  mutable-link,
  ...
}: let
  quickstart-file = pkgs.runCommandNoCCLocal "emacs-quickstart-file" {emacs = lib.getExe config.programs.emacs.finalPackage;} ''
    $emacs --batch \
      --eval "(setq package-quickstart-file \"$(pwd)/package-quickstart.el\")" \
      -f package-activate-all \
      -f package-quickstart-refresh
    cp package-quickstart.elc $out
  '';
  init-substituted = pkgs.substituteAll {
    src = ./config.el;
    # See explanations in ./config.org
    consult_mu_src = sources.consult-mu.src;
    consult_omni_src = sources.consult-omni.src;
  };
  init = with pkgs;
    runCommandNoCCLocal "emacs-byte-compile-init" {
      nativeBuildInputs = [
        config.programs.emacs.finalPackage
        # Needed to load Magit
        git
      ];
    } ''
      cp ${init-substituted} config.el
      emacs --batch \
        -f batch-byte-compile \
        config.el
      cp config.elc $out
    '';
in {
  # Fresh versions of packages
  nixpkgs.overlays = [inputs.emacs-overlay.overlays.package];

  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-pgtk;
    overrides = self: super:
      import ./my-packages.nix {
        inherit sources;
        # Use `super` since some packages are overrides.
        epkgs = super;
      };
    extraPackages = epkgs:
      with epkgs; [
        # Essentials
        no-littering
        gcmh
        el-patch
        # Keybinds
        meow
        meow-tree-sitter
        ace-window
        avy
        casual
        casual-avy
        # Appearance
        ef-themes
        doom-modeline
        minions
        writeroom-mode
        diff-hl
        nyan-mode
        spacious-padding
        eldoc-box
        indent-bars
        # Completion
        vertico
        orderless
        corfu
        cape
        marginalia
        consult
        consult-dir
        embark
        embark-consult
        # Tools
        helpful
        elisp-demos
        ligature
        magit
        git-timemachine
        magit-todos
        forge
        git-link
        envrc
        pulsar
        tempel
        eglot-tempel
        pdf-tools
        copilot
        copilot-chat
        zoxide
        focus
        hl-todo
        consult-todo
        jinx
        # Currently fails to build
        # el-easydraw
        package-lint-flymake
        llm
        treesit-fold
        edit-indirect
        apheleia
        vundo
        undo-fu-session
        keycast
        gptel
        gptel-quick
        expreg
        wgrep
        smartparens
        nerd-icons
        nerd-icons-completion
        nerd-icons-corfu
        nerd-icons-dired
        disproject
        atomic-chrome
        esup
        # Languages
        treesit-grammars.with-all-grammars
        parinfer-rust-mode
        sly
        sly-macrostep
        sly-quicklisp
        rustic
        nix-ts-mode
        typst-ts-mode
        nushell-mode
        just-mode
        justl
        gnuplot
        auctex
        cdlatex
        web-mode
        emmet-mode
        d2-mode
        csv-mode
        haskell-ts-mode
        uiua-ts-mode
        # Org
        org-contrib
        org-modern
        org-modern-indent
        org-ql
        org-appear
        org-make-toc
        org-download
        org-autolist
        org-anki
        org-overdrive
        org-noter
        org-sliced-images
        org-popup-posframe
        org-typst
        htmlize
        git-auto-commit-mode
        dslide
        org-re-reveal
        ox-hugo
        ob-d2
        # Notes
        denote
        denote-explore
        consult-denote
        citar
        citar-embark
        citar-denote
        biblio
        # Applications
        dirvish
        osm
        tldr
        mu4e
        eat
        eshell-atuin
        eshell-syntax-highlighting
        verb
        spray
        calfw
        calfw-org
        nov
        ement
      ];
  };

  services.emacs = {
    enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    imagemagick # For dirvish image preview
    nil
    alejandra
    ltex-ls
  ];

  xdg.configFile = {
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/init.el".source = init-substituted;
    "emacs/init.elc".source = init;
    "emacs/package-quickstart.elc".source = quickstart-file;
    "emacs/private.json".text = builtins.toJSON private;
    "emacs/tempel".source = mutable-link ./snippets;
  };
  xdg.dataFile = {
    "revealjs".source = sources.revealjs.src;
  };
  xdg.mimeApps.defaultApplications = {
    "text/plain" = "emacsclient.desktop";
    "text/org" = "emacsclient.desktop";
    "application/pdf" = "emacsclient.desktop";
    "x-scheme-handler/mailto" = "emacsclient.desktop";
  };

  # For `consult-omni-man`
  programs.man.generateCaches = true;
}
