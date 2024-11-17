{
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
  cfg = config.my.user;
in {
  options.my.user = {
    name = mkOption {
      description = "Username of personal user";
      type = types.nonEmptyStr;
      default = "ad";
      readOnly = true;
    };
    extraGroups = mkOption {
      description = "Extra groups for personal user";
      type = types.listOf types.nonEmptyStr;
      default = [];
    };
    extraConfig = mkOption {
      description = "Extra user configuration options";
      type = types.attrs;
      default = {};
    };
  };

  config = {
    sops.secrets.user-password = {
      neededForUsers = true;
    };

    users.mutableUsers = false;

    my.user.extraGroups = ["wheel"];
    users.users.${cfg.name} =
      {
        inherit (cfg) extraGroups;

        isNormalUser = true;
        createHome = true;
        hashedPasswordFile = config.sops.secrets.user-password.path;
      }
      // cfg.extraConfig;
  };
}
