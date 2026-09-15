{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.default
  ];

  hjem.users.${config.my.user.name}.enable = true;

  my.persist.local.directories = ["/var/lib/hjem"];
}
