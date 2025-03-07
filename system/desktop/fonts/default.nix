{pkgs, ...}: {
  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    # From default packages
    freefont_ttf
    liberation_ttf
    gyre-fonts
    unifont

    (iosevka-bin.override {variant = "SS18";})
    (iosevka-bin.override {variant = "Slab";})
    (iosevka-bin.override {variant = "Aile";})
    (iosevka-bin.override {variant = "Etoile";})
    my.monolisa
    nerd-fonts.symbols-only
    (google-fonts.override {fonts = ["Karla"];})
    atkinson-hyperlegible
    # TODO Switch to this when nixpkgs input is updated.
    # atkinson-hyperlegible-next
    twitter-color-emoji
  ];
}
