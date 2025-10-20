{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.freshrss;
in {
  services.freshrss = {
    enable = true;
    webserver = "nginx";
    virtualHost = "feeds.adtailnet";
    baseUrl = "http://feeds.adtailnet";
    # Don't worry, this instance isn't public.
    passwordFile = pkgs.writeText "freshrss-default-password" "admin";
  };

  my.persist.local.directories = [
    {
      directory = cfg.dataDir;
      user = cfg.user;
      # The group is automatically set to the same as the user:
      # https://github.com/NixOS/nixpkgs/blob/5e2a59a5b1a82f89f2c7e598302a9cacebb72a67/nixos/modules/services/web-apps/freshrss.nix#L306-L312
      group = cfg.user;
      mode = "700";
    }
  ];
}
