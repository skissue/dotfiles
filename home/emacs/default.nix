{
  config,
  pkgs,
  inputs,
  private,
  sources,
  mutable-link,
  ...
}: let
  compile = file: extraInputs:
    with pkgs;
      runCommandNoCCLocal "emacs-compile-${baseNameOf file}" {
        nativeBuildInputs =
          [
            config.programs.emacs.finalPackage
          ]
          ++ extraInputs;
      } ''
        cp ${file} input.el
        # Some packages are annoying and create directories in $HOME when
        # loaded. To deal with them, set home to this temporary build directory
        # so it doesn't error out.
        export HOME=$(pwd)
        emacs --batch \
          -f batch-byte-compile \
          input.el
        cp input.elc $out
      '';
  quickstart-file =
    pkgs.runCommandNoCCLocal "emacs-quickstart-file" {
      nativeBuildInputs = [config.programs.emacs.finalPackage];
    } ''
      emacs --batch \
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
  early-init = compile ./early-init.el [];
  # Git needed to load Magit at compile-time.
  init = compile init-substituted [pkgs.git];
in {
  # Fresh versions of packages
  nixpkgs.overlays = [inputs.emacs-overlay.overlays.package];

  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-igc-pgtk;
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
        ultra-scroll
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
        yasnippet
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
        inline-diff
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
        hyprlang-ts-mode
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
        nice-org-html
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
        elfeed
        elfeed-protocol
        elfeed-org
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
    "emacs/early-init.elc".source = early-init;
    "emacs/init.el".source = init-substituted;
    "emacs/init.elc".source = init;
    "emacs/package-quickstart.elc".source = quickstart-file;
    "emacs/private.json".text = builtins.toJSON private;
    "emacs/snippets".source = mutable-link ./snippets;
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
