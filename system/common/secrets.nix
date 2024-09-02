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

  # Automatically add host keys to decryption keys
  systemd.services.set-sops-keys = {
    wantedBy = ["multi-user.target"];
    path = with pkgs; [doas ssh-to-age];
    script = ''
      doas -u ${user.name} mkdir -p ${user.home}/.config/sops/age
      ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key -o ${user.home}/.config/sops/age/keys.txt
      chown -R ${user.name}:${user.group} ${user.home}/.config/sops
      chmod -R 700 ${user.home}/.config/sops
    '';
  };
}
