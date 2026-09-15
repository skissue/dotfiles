# NixOS specialisations setup for toggling mutable links. See
# https://wiki.nixos.org/wiki/Specialisation for details.
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options = {
    my.enable-mutable-links = lib.mkEnableOption "mutable-links";
  };

  config = {
    _module.args.mutable-link = path:
      assert lib.types.path.check path; let
        relative = lib.strings.removePrefix (toString self) (toString path);
        full = "/etc/dotfiles" + relative;
      in
        if config.my.enable-mutable-links
        then
          pkgs.runCommandLocal "mutable-link-${relative}" {inherit full;} ''
            ln -s "$full" "$out"
          ''
        else path;

    specialisation.mutable-links.configuration = {
      my.enable-mutable-links = true;
      # For `nh`; see
      # https://github.com/viperML/nh/blob/master/README.md#specialisations-support
      environment.etc."specialisation".text = "mutable-links";
    };
  };
}
