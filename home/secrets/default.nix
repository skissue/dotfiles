{
  config,
  self,
  inputs,
  osConfig,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  _module.args.secretsDir = "${self}/secrets";
  sops = {
    inherit (osConfig.sops) defaultSopsFile;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
