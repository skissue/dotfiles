{pkgs, ...}: {
  imports = [
    ./direnv
    ./nix
    ./nushell
    ./starship
  ];

  programs.atuin.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    bat
    coreutils
    fd
    file
    jq
    just
    sd
    unzip
    zip
  ];
}
