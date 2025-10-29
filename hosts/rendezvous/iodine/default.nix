{
  config,
  lib,
  private,
  ...
}: {
  sops.secrets.iodine-password = let
    # Hardcoded user.
    user = config.users.users.iodined;
  in {
    owner = user.name;
    group = user.group;
  };

  services.iodine.server = {
    enable = true;
    domain = private.domain.iodine;
    # Given example, works fine.
    ip = "172.16.10.1/24";
    passwordFile = config.sops.secrets.iodine-password.path;
    # 53 and 5353 are taken by systemd-resolved.
    extraConfig = "-p 5354";
  };

  # DNAT external DNS traffic to iodine.
  networking.nftables.tables.iodine-nat = {
    family = "inet";
    content = ''
      chain prerouting {
        type nat hook prerouting priority 0;
        udp dport 53 redirect to 5354
      }
    '';
  };
  networking.firewall.allowedUDPPorts = [5354];
  networking.firewall.interfaces."dns0".allowedTCPPorts =
    config.services.openssh.ports
    ++ lib.optional config.services.iperf3.enable config.services.iperf3.port;
  # Mosh
  networking.firewall.interfaces."dns0".allowedUDPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];
}
