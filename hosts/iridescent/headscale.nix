{
  config,
  pkgs,
  private,
  ...
}: let
  domain = private.domain.tailnet';
  port = config.services.headscale.port;
in {
  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://${domain}";

      prefixes = {
        v4 = "100.72.0.0/16";
        v6 = "fd7a:115c:a1e0::/48";
        allocation = "random";
      };

      dns = {
        magic_dns = true;
        base_domain = "in.${domain}";
        override_local_dns = true;
        nameservers.global = ["9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9"];
      };
    };
  };

  # Access to administratation tools.
  environment.systemPackages = [pkgs.headscale];

  # Let Caddy automatically get the HTTPS certificate.
  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:${toString port}
    '';
  };
}
