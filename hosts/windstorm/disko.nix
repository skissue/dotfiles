{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk.nvme0n1 = {
    device = "/dev/nvme0n1";
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
          end = "-80G";
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
                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "30G";
                };
              };
            };
          };
        };
      };
    };
  };
}
