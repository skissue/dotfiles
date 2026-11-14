{
  config,
  inputs,
  secretsDir,
  ...
}: {
  imports = [inputs.rbsgo.nixosModules.default];

  services.rbsgo = {
    enable = true;
    configFile = config.sops.secrets.rbsgo-config.path;
  };

  sops.secrets.rbsgo-config = {
    sopsFile = "${secretsDir}/prowler.yaml";
    restartUnits = ["rbsgo.service"];
  };

  # TODO web proxy

  my.persist.data.directories = [
    {
      directory = "/var/lib/rbsgo";
      user = config.users.users.rbsgo.name;
      group = config.users.users.rbsgo.group;
      mode = "700";
    }
  ];
}
