{
  config,
  inputs,
  private,
  secretsDir,
  ...
}: let
  domain = "rbsgo.${private.domain.internal}";
in {
  imports = [inputs.rbsgo.nixosModules.default];

  services.rbsgo = {
    enable = true;
    configFile = config.sops.secrets.rbsgo-config.path;
  };

  sops.secrets.rbsgo-config = {
    sopsFile = "${secretsDir}/prowler.yaml";
    restartUnits = ["rbsgo.service"];
  };

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "internal";
    # TODO this should probably live at a lower unified level (firewall?)
    # NOTE must match listening address in the config
    extraConfig = ''
      @not-tailnet not remote_ip 100.72.0.0/16 fd7a:115c:a1e0::/48
      respond @not-tailnet 403
      reverse_proxy http://127.0.0.1:3003
    '';
  };

  my.persist.data.directories = [
    {
      directory = "/var/lib/rbsgo";
      user = config.users.users.rbsgo.name;
      group = config.users.users.rbsgo.group;
      mode = "700";
    }
  ];
}
