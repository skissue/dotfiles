{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "lib";
    };
    lib.url = "github:nix-community/nixpkgs.lib";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";

    private.url = "git+ssh://ad@rendezvous/home/ad/dotfiles.private";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-index = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
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
      inputs.flake-parts.follows = "flake-parts";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    eww.url = "github:elkowar/eww";

    # https://github.com/hyprwm/Hyprland/issues/5891#issuecomment-2133152891
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      # Without this, Mesa version mismatches happen every so often.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprchroma = {
      url = "github:skissue/Hyprchroma";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };
    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };
    hyprscroller = {
      url = "github:dawsers/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    flake-parts,
    nixpkgs,
    ...
  } @ inputs: let
    lib = inputs.lib.lib;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        inputs.devshell.flakeModule
        ./hosts
      ];

      perSystem = {
        pkgs,
        system,
        inputs',
        ...
      }: {
        # TODO Why is this needed?
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "steam-unwrapped"
              "steam-run"
            ];
        };

        packages = lib.genAttrs (lib.attrNames (builtins.readDir ./packages)) (p: pkgs.callPackage (import ./packages/${p}) {});

        devshells.default = with pkgs; {
          commands = [
            {
              name = "deploy";
              package = inputs'.deploy-rs.packages.default;
            }
            {package = inputs'.nixos-anywhere.packages.default;}
            {package = inputs'.home-manager.packages.default;}
            {package = sops;}
            {package = ssh-to-age;}
            {package = nvfetcher;}
          ];
        };

        formatter = pkgs.alejandra;
      };
    };

  nixConfig = {
    allow-import-from-derivation = true;
  };
}
