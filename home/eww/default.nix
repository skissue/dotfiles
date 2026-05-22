{
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  xdg.configFile."eww".source = mutable-link ./.;

  home.packages = with pkgs; [hyprland-workspaces];
}
