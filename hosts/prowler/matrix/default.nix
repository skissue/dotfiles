{
  config,
  pkgs,
  inputs,
  ...
}: {
  services.matrix-conduit = {
    enable = true;
    package = inputs.conduwuit.packages.${pkgs.system}.default;
    settings = {
      global = {
        server_name = "matrix.adtailnet";
        allow_registration = false;
        allow_federation = false;
      };
    };
  };

  services.nginx.virtualHosts."matrix.adtailnet" = {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.matrix-conduit.settings.global.port}";
      proxyWebsockets = true;
    };
  };

  services.mautrix-signal = {
    enable = true;
    settings = {
      homeserver = {
        domain = "matrix.adtailnet";
      };
      bridge = {
        permissions = {
          "@ad:matrix.adtailnet" = "admin";
        };
      };
      matrix = {
        delivery_receipts = true;
        sync_direct_chat_list = true;
      };
    };
  };

  # Using systemd DynamicUser, so we have to hardcode the path.
  my.persist.data.directories = [
    {
      directory = "/var/lib/private/matrix-conduit";
      mode = "700";
    }
    {
      directory = "/var/lib/mautrix-signal";
      user = "mautrix-signal";
      group = "mautrix-signal";
    }
  ];
}
