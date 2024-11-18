{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index.hmModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [nix-output-monitor];
}
