{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.private.nixosModules.default
    ../impermanence/options.nix # Always include so we can define paths in various modules
    ../networking
    ./chaotic.nix
    ./logind.nix
    ./mutable-links.nix
    ./nix.nix
    ./secrets.nix
    ./security.nix
    ./ssh.nix
    ./sudo.nix
    ./user.nix
  ];

  time.timeZone = lib.mkDefault "America/New_York";

  system.configurationRevision = inputs.self.rev or "dirty";
  # I'm using Flakes, there's no time I don't want Git
  programs.git.enable = true;
}
