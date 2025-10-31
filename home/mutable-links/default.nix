# Inspired by https://github.com/outfoxxed/impurity.nix
{
  lib,
  pkgs,
  self,
  osConfig,
  ...
}: let
  enable = osConfig.my.enable-mutable-links;
  immutableRoot = self;
  mutableRoot = "/etc/dotfiles";

  relativePath = path:
    assert lib.types.path.check path;
      lib.strings.removePrefix (toString immutableRoot) (toString path);

  createPath = path: let
    relative = relativePath path;
    full = mutableRoot + relative;
    mutable =
      pkgs.runCommandLocal "mutable-link-${relative}"
      {inherit full;}
      "ln -s $full $out";
  in
    if enable
    then mutable
    else path;
in {
  _module.args.mutable-link = createPath;
}
