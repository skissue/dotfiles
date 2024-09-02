{
  config,
  pkgs,
  ...
}: let
  interface = "wlp1s0";
in {
  boot.initrd = {
    availableKernelModules = ["ccm" "ctr" "ath10k_pci"]; # Crypto modules and wireless driver

    systemd = {
      enable = true;

      packages = [pkgs.wpa_supplicant]; # For units
      initrdBin = [pkgs.wpa_supplicant]; # For the actual executable
      targets.initrd.wants = ["wpa_supplicant@${interface}.service"];

      network.enable = true;
      network.networks."10-wlan" = {
        matchConfig.Name = interface;
        networkConfig.DHCP = "yes";
      };

      # Prevent WPA supplicant from requiring `sysinit.target`.
      services."wpa_supplicant@".unitConfig.DefaultDependencies = false;

      users.root.shell = "/bin/systemd-tty-ask-password-agent";
    };

    secrets."/etc/wpa_supplicant/wpa_supplicant-${interface}.conf" =
      /root/wpa_supplicant.conf;

    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        hostKeys = [
          "/etc/secrets/initrd/ssh_host_ed25519_key"
        ];
        authorizedKeys = config.users.users.${config.my.user.name}.openssh.authorizedKeys.keys;
      };
    };
  };

  environment.persistence."/local" = {
    directories = [
      {
        directory = "/etc/secrets";
        mode = "700";
      }
    ];
    files = ["/root/wpa_supplicant.conf"];
  };
}
