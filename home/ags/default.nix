{
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  imports = [inputs.ags.homeManagerModules.default];

  programs.ags = {
    enable = true;
    configDir = mutable-link ./.;
  };

  home.packages = with pkgs; [sassc];
}
