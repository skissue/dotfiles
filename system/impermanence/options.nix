{lib, ...}: let
  inherit (lib) types;
  option = lib.mkOption {
    type = types.listOf (types.either types.path types.attrs);
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
  };
}
