{
  description = "Dummy rbsgo input for configuration checks; never deploy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: {
    packages.x86_64-linux.default =
      nixpkgs.legacyPackages.x86_64-linux.runCommand "rbsgo-mock" {} "mkdir -p $out";

    nixosModules.default = {
      config,
      lib,
      ...
    }: {
      options.services.rbsgo = {
        enable = lib.mkEnableOption "rbsgo";
        configFile = lib.mkOption {type = lib.types.path;};
      };

      config = lib.mkIf config.services.rbsgo.enable {
        users.users.rbsgo = {
          isSystemUser = true;
          group = "rbsgo";
        };
        users.groups.rbsgo = {};
        warnings = ["Using the mock rbsgo input: this configuration is for checks only, not deployment."];
      };
    };
  };
}
