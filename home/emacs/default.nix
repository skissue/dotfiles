{
  config,
  pkgs,
  inputs,
  private,
  sources,
  mutable-link,
  ...
}: let
  myPackages = import ./my-packages.nix {
    inherit sources;
    epkgs = pkgs.emacsPackagesFor config.programs.emacs.package;
  };
in {
  # Fresh versions of packages
  nixpkgs.overlays = [inputs.emacs-overlay.overlays.package];

  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-pgtk.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [./transparent-box.patch];
    });
    extraPackages = epkgs:
      with epkgs;
      with myPackages; [
        # Essentials
        no-littering
        gcmh
        persistent-scratch
        f
        # Keybinds
        devil
        multiple-cursors
        ace-window
        avy
        casual-avy
        casual-calc
        # Appearance
        doom-themes
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
        embark
        embark-consult
        eglot-booster
        # Tools
        helpful
        elisp-demos
        consult
        consult-dir
        ligature
        magit
        git-timemachine
        magit-todos
        forge
        envrc
        yasnippet
        yasnippet-snippets
        auto-yasnippet
        pulsar
        pdf-tools
        treesit-grammars.with-all-grammars
        copilot
        zoxide
        focus
        hl-todo
        consult-todo
        topsy
        jinx
        dashboard
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
        transpose-frame
        expreg
        wgrep
        smartparens
        nerd-icons
        # Languages
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
        # Org
        org-contrib
        org-modern
        org-modern-indent
        org-roam
        org-roam-ui
        org-ql
        org-appear
        org-fragtog
        org-auto-tangle
        org-make-toc
        org-download
        org-autolist
        org-anki
        inline-anki
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
        emms
        osm
        syncthing-el
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
    nodejs # Copilot
    nil
    alejandra
    ltex-ls
    emacs-lsp-booster
  ];

  xdg.configFile = {
    "emacs/early-init.el".source = ./early-init.el;
    "emacs/init.el".source = with pkgs;
      substituteAll {
        src = ./config.el;
        # See explanations in ./config.org
        doom_snippets_src = sources.doom-snippets.src;
        consult_mu_src = sources.consult-mu.src;
        consult_omni_src = sources.consult-omni.src;
      };
    "emacs/private.json".text = builtins.toJSON private;
    # Custom icon because webp can be properly transparent
    "emacs/logo.webp".source = ./logo.webp;
    "emacs/snippets".source = mutable-link ./snippets;
  };
  xdg.dataFile = {
    "revealjs".source = sources.revealjs.src;
  };

  # For `consult-omni-man`
  programs.man.generateCaches = true;
}
