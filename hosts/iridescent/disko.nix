{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices = {
    disk.vda = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # For GRUB to install BIOS bootloader.
          bios = {
            start = "0";
            size = "1M";
            type = "EF02";
            # I don't know what this means, but it was in the example.
            attributes = [0];
          };
          # For GRUB to put kernel/initrd, since it cannot read Bcachefs.
          boot = {
            size = "256M";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
            };
          };
          nixos = {
            end = "-1G";
            content = {
              type = "bcachefs";
              filesystem = "bcachefs_root";
              label = "vda";
              extraFormatArgs = [
                "--discard"
              ];
            };
          };
          swap = {
            start = "-1G";
            size = "100%";
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
        };
      };
    };

    bcachefs_filesystems.bcachefs_root = {
      type = "bcachefs_filesystem";
      extraFormatArgs = [
        "--fs_label=nixos"
        "--block_size=4k"
        "--compression=lz4"
        "--background_compression=zstd:9"
      ];
      subvolumes = {
        "@blank_root" = {
        };
        "@root" = {
          mountpoint = "/";
        };
        "@nix" = {
          mountpoint = "/nix";
        };
        "@log" = {
          mountpoint = "/var/log";
        };
        "@local" = {
          mountpoint = "/local";
        };
        "@data" = {
          mountpoint = "/data";
        };
      };
    };
  };
}
