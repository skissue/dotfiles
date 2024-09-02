{
  lib,
  host,
  ...
}: {
  imports = [./tailscale];

  networking = {
    hostName = host;
    useDHCP = lib.mkDefault true;
    nameservers = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" "2620:fe::fe#dns.quad9.net" "2620:fe::9#dns.quad9.net"];
  };

  networking.nftables = {
    enable = true;
    flushRuleset = false; # Breaks active Mullvad/Tailscale connection rules
  };

  # Acts as cache, layering on top of Tailscale's DNS server
  services.resolved = {
    enable = lib.mkDefault true;
    fallbackDns = [""]; # Never fallback (don't want to use default servers)
    dnsovertls = "true";
  };
}
