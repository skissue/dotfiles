{
  pkgs,
  inputs,
  sources,
}: let
  inherit (pkgs) lib;
  emacsPackage = inputs.emacs-overlay.packages.${pkgs.stdenv.hostPlatform.system}.emacs-igc-pgtk;
  grammars = pkgs.emacsPackages.treesit-grammars.with-all-grammars;
in
  (inputs.twist.lib.makeEnv {
    inherit pkgs emacsPackage;
    initFiles = [./config.el];
    initReader = _: {};
    extraPackages = import ./packages.nix;
    lockDir = ./lock;
    # Their sources are already pinned by inputs.funn and pkgs.mu, not Twist's lock.
    localPackages = ["funn" "mu4e"];
    registries = [
      {
        type = "melpa";
        path = ./recipes;
      }
      {
        type = "melpa";
        path = "${sources.melpa.src}/recipes";
        # MELPA version has broken metadata, use ELPA's instead
        exclude = ["async"];
      }
      {
        type = "archive";
        url = "https://elpa.gnu.org/packages/";
      }
      {
        type = "archive";
        url = "https://elpa.nongnu.org/nongnu/";
      }
    ];
    inputOverrides = {
      funn.src = inputs.funn;
      # mu supplies generated Lisp matching the executable used by email.
      mu4e.src = "${pkgs.mu.mu4e}/share/emacs/site-lisp/mu4e";
    };
    extraSiteStartElisp = ''
      (add-to-list 'treesit-extra-load-path "${grammars}/lib")
    '';
  }).overrideScope (_: super: {
    executablePackages = with pkgs; [
      vips
      ffmpegthumbnailer
      mediainfo
      svgbob
      (lib.getBin lz4)
    ];
    elispPackages = super.elispPackages.overrideScope (import ./build-overrides.nix {
      inherit pkgs;
      emacs = emacsPackage;
    });
  })
