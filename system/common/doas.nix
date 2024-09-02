{
  config,
  lib,
  ...
}: let
  wheelNeedsPassword = config.security.doas.wheelNeedsPassword;
in {
  security = {
    sudo.enable = lib.mkDefault false;
    doas = {
      enable = true;
      # We basically have to manually set wheelNeedsPassword because of how doas parses rules
      extraRules = lib.singleton {
        groups = ["wheel"];
        keepEnv = true;
        persist = wheelNeedsPassword; # Cannot be combined with noPass, so we have to ensure they're XOR
        noPass = !wheelNeedsPassword;
      };
    };
  };
}
