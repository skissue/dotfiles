{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  config = {
    home-manager = {
      useUserPackages = true;
      extraSpecialArgs = {
        inherit self inputs;
        sources = pkgs.callPackage (import "${self}/_sources/generated.nix") {};
      };
      users.${config.my.user.name} = {
        imports = [
          "${self}/home"
          (
            let
              path = "${self}/hosts/${config.networking.hostName}/home";
            in
              if builtins.pathExists path
              then path
              else {}
          )
        ];
      };
    };
  };
}
