{pkgs, ...}: {
  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    # From default packages
    freefont_ttf
    liberation_ttf
    gyre-fonts
    unifont

    my.monolisa
    nerd-fonts.symbols-only
    maple-mono.NF
    atkinson-hyperlegible-next
    twitter-color-emoji
  ];
}
