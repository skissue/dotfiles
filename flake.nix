{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    impermanence = {
      url = "github:nix-community/impermanence";
      # Only used for tests.
      inputs.nixpkgs.follows = "";
    };
    persist-retro.url = "github:Geometer1729/persist-retro";

    private.url = "git+ssh://ad@prowler/home/ad/dotfiles.private";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bouncer = {
      url = "github:skissue/bouncer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    crack = {
      url = "github:skissue/gxy?dir=crack";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elisp-extra = {
      url = "github:skissue/gxy?dir=elisp";
      flake = false;
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    eww.url = "github:elkowar/eww";
    git-annex-backend-XBLAKE3 = {
      url = "github:skissue/git-annex-backend-XBLAKE3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    koito = {
      url = "github:skissue/koito-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
    (import ./hosts inputs)
    // {
      overlays.default = final: prev: {
        my-sources-private = inputs.private.sources;
        my =
          lib.genAttrs
          (lib.attrNames (builtins.readDir ./packages))
          (p: final.callPackage (import ./packages/${p}) {});
      };

      formatter.${system} = pkgs.alejandra;

      devShells.${system} = let
        mkShell = inputs.devshell.legacyPackages.${system}.mkShell;
      in {
        default = mkShell {
          commands = with pkgs; [
            {package = sops;}
            {package = ssh-to-age;}
            {package = nvfetcher;}
          ];
        };
        deploy = mkShell {
          commands = with pkgs; [
            {
              name = "deploy";
              package = inputs.deploy-rs.packages.${system}.default;
            }
            {package = inputs.nixos-anywhere.packages.${system}.default;}
            {package = sops;}
            {package = ssh-to-age;}
            {package = nvfetcher;}
          ];
        };
      };
    };

  nixConfig = {
    allow-import-from-derivation = true;
  };
}
