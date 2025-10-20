{
  config,
  pkgs,
  private,
  ...
}: let
  domain = "hs.${private.domain.personal}";
  tailnetDomain = private.domain.tailnet;
  port = config.services.headscale.port;
in {
  imports = [./dns.nix];

  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://${domain}";
      prefixes = {
        v4 = "100.69.0.0/16";
        v6 = "fd7a:115c:a1e0::/48";
      };
      dns = {
        magic_dns = true;
        # Unbound running on rendezvous
        nameservers.global = ["100.69.0.8" "fd7a:115c:a1e0::1"];
        base_domain = tailnetDomain;
      };
    };
  };
  environment.systemPackages = [pkgs.headscale];

  # Stolen from
  # https://github.com/kradalby/dotfiles/blob/4489cdbb19cddfbfae82cd70448a38fde5a76711/machines/headscale.oracldn/headscale.nix#L61-L91
  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "personal";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };
}
