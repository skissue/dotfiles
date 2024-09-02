{
  self,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  hosts = builtins.filter (f: f != "default.nix") (lib.attrNames (builtins.readDir ./.));
in {
  flake = {
    nixosConfigurations = let
      mkHost = host:
        lib.nixosSystem {
          modules = [
            ./${host}
            ./${host}/hardware-configuration.nix
            "${self}/system/common"
          ];
          specialArgs = {
            inherit self inputs host;
            mkModulesList = map (m: "${self}/system/${m}");
          };
        };
    in
      lib.genAttrs hosts mkHost;

    deploy = let
      mkDeploy = host: {
        hostname = host;
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${host};
        };
      };
    in {
      sudo = "doas -u";
      nodes = lib.genAttrs (builtins.attrNames self.nixosConfigurations) mkDeploy;
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
