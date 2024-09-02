# Inspired by https://github.com/outfoxxed/impurity.nix
{
  lib,
  pkgs,
  self,
  ...
}: let
  # Hack to enable when the --impure flag is passed or when using
  # standalone home-manager; repurposing an existing option for
  # convenience. PATH always exists (at least, it should), but
  # `getEnv` returns an empty string when in pure evaluation mode.
  enable = builtins.getEnv "PATH" != "";
  immutableRoot = self;
  mutableRoot = "/etc/dotfiles";

  relativePath = path:
    assert lib.types.path.check path;
      lib.strings.removePrefix (toString immutableRoot) (toString path);

  createPath = path: let
    relative = relativePath path;
    full = mutableRoot + relative;
    mutable = pkgs.runCommand "mutable-link-${relative}" {} "ln -s ${full} $out";
  in
    if enable
    then mutable
    else path;
in {
  _module.args.mutable-link = createPath;
}
