{
  config,
  pkgs,
  inputs,
  self,
  secretsDir,
  ...
}: let
  user = config.users.users.${config.my.user.name};
in {
  imports = [
    inputs.sops-nix.nixosModules.default
  ];
  _module.args.secretsDir = "${self}/secrets";

  sops.defaultSopsFile = "${secretsDir}/common.yaml";
}
