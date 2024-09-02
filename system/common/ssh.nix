{config, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = false; # Using Tailscale
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.${config.my.user.name}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRMZR0lD/uE1zpUIDbBLJoQKMnbpkTO1Y2EbEhfG38u Ad"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8YKBCF+gldnk4GnyibOqjSRDgZr0YTPHiyJeqIcdUO"
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
