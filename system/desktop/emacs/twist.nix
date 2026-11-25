{
  pkgs,
  inputs,
  sources,
}: let
  inherit (pkgs) lib;
  emacsPackage = inputs.emacs-overlay.packages.${pkgs.stdenv.hostPlatform.system}.emacs-igc-pgtk;
  # Touchtypst needs latest bleeding grammar and nixpkgs is old
  grammars = pkgs.emacsPackages.treesit-grammars.with-grammars (_:
    (pkgs.tree-sitter-grammars.overrideScope (_: prev: {
      tree-sitter-typst = prev.tree-sitter-typst.overrideAttrs {
        inherit (sources.tree-sitter-typst) src;
        version = "unstable-${sources.tree-sitter-typst.date}";
      };
    })).allGrammars);
  # HACK twist uses fetchTree by default internally which redownloads (almost) every time for reasons,
  # force it to use fetchTarball instead, see: <https://github.com/NixOS/nix/issues/12751>
  archiveOverrides = lib.mapAttrs (_name: _locked: _: prev:
    lib.optionalAttrs
    (prev.inventory.type == "archive" && prev.archive.type == "tarball")
    {
      src = {
        inherit (prev.archive) narHash;
        outPath = builtins.fetchTarball {
          inherit (prev.archive) url;
          sha256 = prev.archive.narHash;
        };
      };
    })
  (lib.importJSON ./lock/archive.lock);
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
    inputOverrides =
      archiveOverrides
      // {
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
