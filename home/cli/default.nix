{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index.hmModules.nix-index
    ./direnv
    ./nushell
    ./starship
  ];

  programs.atuin.enable = true;
  programs.zoxide.enable = true;
  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    aria
    bat
    bottom
    coreutils
    fd
    file
    jq
    just
    ripgrep
    ripgrep-all
    sd
    unzip
    zip
  ];
}
