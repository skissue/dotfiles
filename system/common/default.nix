{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.private.nixosModules.default
    ../impermanence/options.nix # Always include so we can define paths in various modules
    ../networking
    ../ntfy-alerts
    ./doas.nix
    ./mutable-links.nix
    ./nix.nix
    ./secrets.nix
    ./security.nix
    ./ssh.nix
    ./user.nix
  ];

  time.timeZone = lib.mkDefault "America/New_York";

  system.configurationRevision =
    (inputs.self.rev or "dirty")
    + (
      if (builtins.getEnv "PATH" != "")
      then "-impure"
      else ""
    );
  # I'm using Flakes, there's no time I don't want Git
  environment.systemPackages = [pkgs.git];
}
