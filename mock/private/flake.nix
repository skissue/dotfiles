{
  description = "Dummy private input for configuration checks; never deploy";

  outputs = {self}: let
    private = {
      name = "Example User";
      email = {
        personal = "personal@example.invalid";
        public = "public@example.invalid";
        work = "work@example.invalid";
      };
      user.work = "example-user";
      domain = {
        private = "private.example.invalid";
        tailnet' = "tailnet.example.invalid";
        wasteoftime = "wasteoftime.example.invalid";
      };
    };
  in {
    nixosModules = {
      default = {
        _module.args.private = private;
        warnings = ["Using the mock private input: this configuration is for checks only, not deployment."];
      };
      iridescent-networking = {
        networking.interfaces.eth0.ipv4.addresses = [
          {
            address = "192.0.2.2";
            prefixLength = 24;
          }
        ];
        networking.defaultGateway = {
          address = "192.0.2.1";
          interface = "eth0";
        };
      };
    };

    homeManagerModules.default = {
      _module.args.private = private;
    };

    sources = {
      monolisa = ./fonts;
      pragmatapro = ./fonts;
    };
  };
}
