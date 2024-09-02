{
  config,
  lib,
  pkgs,
  ...
}: let
  ip = "10.233.69.3";
in {
  config = {
    containers.ntfy = {
      autoStart = true;
      ephemeral = true;

      privateNetwork = true;
      hostAddress = "10.233.69.1";
      localAddress = ip;

      config = {...}: {
        services.ntfy-sh = {
          enable = true;
          settings = {
            listen-http = ":80";
            base-url = "http://notify.adtailnet";
          };
        };

        networking.firewall.allowedTCPPorts = [80];
        system = {inherit (config.system) stateVersion;};
      };
    };

    services.nginx.virtualHosts = {
      "notify.adtailnet" = {
        locations."/" = {
          proxyPass = "http://${ip}:80";
          proxyWebsockets = true;
        };
      };
    };
  };
}
