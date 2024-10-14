# NixOS specialisations setup for toggling mutable links. See
# https://wiki.nixos.org/wiki/Specialisation for details.
{lib, ...}: {
  options = {
    my.enable-mutable-links = lib.mkEnableOption "mutable-links";
  };
  
  config = {
    specialisation.mutable-links.configuration = {
      my.enable-mutable-links = true;
    };
  };
}
