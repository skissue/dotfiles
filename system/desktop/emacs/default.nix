{
  config,
  pkgs,
  self,
  inputs,
  private,
  mutable-link,
  ...
}: let
  sources = pkgs.callPackage "${self}/_sources/generated.nix" {};
  emacsPackages = ((pkgs.extend inputs.emacs-overlay.overlays.package).emacsPackagesFor
    inputs.emacs-overlay.packages.${pkgs.stdenv.hostPlatform.system}.emacs-igc-pgtk)
    .overrideScope (self: super:
    import ./my-packages.nix {
      inherit inputs sources;
      # Use `super` since some packages are overrides.
      epkgs = super;
    });

  compile = file: extraInputs:
    with pkgs;
      runCommandLocal "emacs-compile-${baseNameOf file}" {
        nativeBuildInputs = [emacs] ++ extraInputs;
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
    pkgs.runCommandLocal "emacs-quickstart-file" {
      nativeBuildInputs = [emacs];
    } ''
      emacs --batch \
        --eval "(setq package-quickstart-file \"$(pwd)/package-quickstart.el\")" \
        -f package-activate-all \
        -f package-quickstart-refresh
      cp package-quickstart.elc $out
    '';
  early-init = compile ./early-init.el [];
  # Git needed to load Magit at compile-time.
  init = compile ./config.el [pkgs.git];
  emacs = emacsPackages.emacsWithPackages (epkgs:
    (with epkgs; [
      # Essentials
      no-littering
      el-patch
      # Elisp
      llama
      aio
      plz
      posframe
      # Keybinds
      meow
      meow-tree-sitter
      ace-window
      avy
      casual
      casual-avy
      # Appearance
      modus-themes
      modus-alabaster
      kusanagi-theme
      doom-modeline
      minions
      writeroom-mode
      diff-hl
      nyan-mode
      spacious-padding
      eldoc-box
      indent-bars
      flyover
      # Completion
      vertico
      vertico-popup-frame
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
      magit
      git-timemachine
      magit-todos
      magit-annex
      forge
      git-link
      git-annex
      envrc
      pulsar
      yasnippet
      pdf-tools
      zoxide
      focus
      hl-todo
      consult-todo
      jinx
      el-easydraw
      package-lint-flymake
      llm
      treesit-fold
      edit-indirect
      apheleia
      vundo
      undo-fu-session
      keycast
      gptel
      gptel-openrouter-models
      gptel-quick
      gptel-aibo
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
      # Fails to build
      # uniline
      dag-draw
      el-search
      # Fails to build
      # agent-shell
      # Languages
      treesit-grammars.with-all-grammars
      parinfer-rust-mode
      sly
      sly-macrostep
      sly-quicklisp
      geiser
      rustic
      nix-ts-mode
      typst-ts-mode
      nushell-ts-mode
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
      kdl-mode
      nim-mode
      kotlin-ts-mode
      bazel
      qml-ts-mode
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
      org-noter
      org-sliced-images
      org-srs
      nice-org-html
      htmlize
      git-auto-commit-mode
      dslide
      org-re-reveal
      ox-hugo
      ox-typst
      ob-d2
      ob-svgbob
      ob-typst
      # Notes
      denote
      denote-org
      denote-journal
      denote-sequence
      consult-denote
      citar
      citar-embark
      # Fails to build right now
      # citar-denote
      biblio
      howm
      funn
      # Applications
      dirvish
      osm
      tldr
      mu4e
      eat
      eshell-atuin
      eshell-syntax-highlighting
      ghostel
      verb
      spray
      calfw
      calfw-org
      nov
      ement
      elfeed
      elfeed-protocol
      elfeed-tube
      elfeed-tube-mpv
      yeetube
      elfin
    ])
    ++ (with pkgs; [
      # Dirvish previews
      vips
      ffmpegthumbnailer
      mediainfo

      svgbob
      (lib.getBin lz4) # reSnap
    ]));
  editor = pkgs.writeShellScript "editor" ''exec ${emacs}/bin/emacsclient "''${@:---create-frame}"'';
in {
  users.users.${config.my.user.name}.packages = [emacs];

  hjem.users.${config.my.user.name} = {
    environment.sessionVariables = {
      EDITOR = editor;
      VISUAL = editor;
    };

    systemd.services.emacs = {
      description = "Emacs text editor";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.runtimeShell} -l -c 'exec ${emacs}/bin/emacs --fg-daemon'";
        SuccessExitStatus = 15;
        Restart = "on-failure";
      };
    };

    xdg.config.files = {
      "emacs/early-init.el".source = ./early-init.el;
      "emacs/early-init.elc".source = early-init;
      "emacs/init.el".source = ./config.el;
      "emacs/init.elc".source = init;
      "emacs/user-lisp".source = inputs.elisp-extra;
      "emacs/package-quickstart.elc".source = quickstart-file;
      "emacs/private.json".text = builtins.toJSON private;
      "emacs/snippets".source = mutable-link ./snippets;
    };
    xdg.data.files."revealjs".source = sources.revealjs.src;
  };
}
