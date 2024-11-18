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
