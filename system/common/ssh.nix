{
  config,
  lib,
  ...
}: {
  services.openssh = {
    enable = true;
    # Using Tailscale, which is unconditionally allowed through the system
    # firewall.
    openFirewall = lib.mkDefault false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.${config.my.user.name}.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAID9JGTxwDN1T9OGFqH8Ixmswn2i0XgUmWhlVfk+PbAScAAAABHNzaDo= Ad"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILHCtSdMw5fIO3e2B5ZNdAbIucoBZ6N/77tm1QYXFmZsAAAABHNzaDo= Ad"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSQO88S8m8AtbWqZ7B6FOiSpnbsKhtqwlLwLvO7E4xe ad@flashpoint"
  ];

  my.persist.local.files = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
  ];

  programs.mosh = {
    enable = true;
    openFirewall = false;
  };
}
