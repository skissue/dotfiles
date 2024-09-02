{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk.sda = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            content = {
              type = "btrfs";
              extraArgs = ["--label" "root"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = ["noatime" "ssd" "compress=zstd"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["noatime" "ssd" "compress=zstd"];
                };
                "/persist/local" = {
                  mountpoint = "/local";
                  mountOptions = ["noatime" "ssd" "compress=zstd"];
                };
                "/persist/data" = {
                  mountpoint = "/data";
                  mountOptions = ["noatime" "ssd" "compress=zstd"];
                };
              };
            };
          };
        };
      };
    };
  };
}
