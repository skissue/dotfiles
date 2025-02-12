{config, ...}: let
  cfg = config.services.tt-rss;
  url = "http://feeds.adtailnet";
in {
  services.tt-rss = {
    enable = true;
    selfUrlPath = url;
    virtualHost = url;
  };

  my.persist.local.directories = [
    {
      directory = cfg.root;
      user = cfg.user;
      # This group is hardcoded:
      # https://github.com/NixOS/nixpkgs/blob/a79cfe0ebd24952b580b1cf08cd906354996d547/nixos/modules/services/web-apps/tt-rss.nix#L635
      group = "tt_rss";
      mode = "700";
    }
  ];
}
