{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.windscribe-nix.nixosModules.default];

  # Login, connection settings and the kill switch are managed by the official app.
  services.windscribe = {
    enable = true;
    package = inputs.windscribe-nix.packages.${pkgs.stdenv.hostPlatform.system}.windscribe;
  };

  # Allow asymmetric routing through VPN tunnels.
  networking.firewall.checkReversePath = "loose";

  # Windscribe configures VPN DNS without overriding resolved's global TLS policy.
  # Its tunnel DNS must not inherit the mandatory DoT setting used for Quad9.
  services.resolved.settings.Resolve.DNSOverTLS = lib.mkForce "false";
}
