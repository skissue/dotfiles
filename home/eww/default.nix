{
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.default;
    configDir = mutable-link ./.;
  };

  home.packages = with pkgs; [hyprland-workspaces];
}
