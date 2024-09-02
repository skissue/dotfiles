{
  config,
  lib,
  pkgs,
  self,
  inputs,
  ...
}: {
  nix = {
    package = pkgs.lix;
    # Add Flake inputs as Nix registry + nixPath inputs (for legacy tooling)
    registry = builtins.mapAttrs (name: val: {flake = val;}) inputs;
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings = {
      # Allow users of the wheel group to interact with the Nix daemon
      trusted-users = ["@wheel"];

      # Automatically optimise store (deduplicate files via hard-linking)
      auto-optimise-store = true;

      # Various binary caches
      substituters = [
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://hyprland.cachix.org"
        "https://attic.kennel.juneis.dog/conduwuit"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "conduwuit:BbycGUgTISsltcmH0qNjFR9dbrQNYgdIAcmViSGoVTE="
      ];
    };

    # Enable Flakes, respect XDG
    extraOptions = ''
      experimental-features = nix-command flakes
      use-xdg-base-directories = true
    '';

    # Automatically collect garbage
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # Make the system usable while building
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";
  };

  nixpkgs = {
    config = {
      # Wall of shame.
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "obsidian"
          "steam"
          "steam-original"
          "steam-run"
          "minecraft-server"
        ];
      permittedInsecurePackages = [
        "nodejs-14.21.3" # WebCord I think
        "electron-25.9.0" # Obsidian
        "olm-3.2.16" # https://github.com/mautrix/go/issues/262
      ];
    };
    overlays = [
      (final: prev: {
        my = self.packages.${pkgs.system};
      })
    ];
  };

  # Default `command-not-found` doesn't work with pure Flakes
  programs.command-not-found.enable = false;
}
