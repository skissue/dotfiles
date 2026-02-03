{
  lib,
  host,
  ...
}: {
  imports = [./tailscale];

  networking = {
    useNetworkd = true;
    hostName = host;
    nameservers = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" "2620:fe::fe#dns.quad9.net" "2620:fe::9#dns.quad9.net"];
  };

  networking.nftables.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve = {
      FallbackDNS = [""]; # Never fallback (don't want to use default servers)
      DNSOverTLS = "true";
    };
  };
}
