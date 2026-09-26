{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.${config.my.user.name}.packages = with pkgs; [
    # TODO remove when merged into nixpkgs:
    # <https://github.com/NixOS/nixpkgs/pull/566678>
    (haskell.lib.appendPatch git-annex ./git-annex-bup-0.34-local-repo.patch)
    inputs.git-annex-backend-XBLAKE3.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
