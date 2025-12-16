{lib, ...}: let
  inherit (lib) types;
  option = lib.mkOption {
    type = types.listOf (types.either types.nonEmptyStr types.attrs);
    default = [];
  };
in {
  options.my.persist = {
    local = {
      directories = option;
      files = option;
    };
    data = {
      directories = option;
      files = option;
    };
    userLocal = {
      directories = option;
      files = option;
    };
    userData = {
      directories = option;
      files = option;
    };
  };
}
