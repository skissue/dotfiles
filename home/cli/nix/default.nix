{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index.homeModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [nix-output-monitor];
}
