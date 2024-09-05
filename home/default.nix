{
  inputs,
  osConfig,
  ...
}: {
  imports = [
    inputs.private.homeManagerModules.default
    ./alacritty
    ./ags
    ./applications
    ./cli
    ./cursors
    ./emacs
    ./email
    ./fuzzel
    ./git
    ./gtk
    ./hyprland
    ./languages
    ./mutable-links
    ./secrets
    ./ssh
    ./xdg
  ];

  home = {
    username = osConfig.my.user.name;
    homeDirectory = osConfig.users.users.${osConfig.my.user.name}.home;
    stateVersion = osConfig.system.stateVersion;
  };

  nixpkgs.overlays = osConfig.nixpkgs.overlays;
  nixpkgs.config = osConfig.nixpkgs.config;

  # Required for greetd to inherit home-manager environment (sessionVariables
  # etc.). Probably also needed for other programs as well.
  home.file.".profile".text = ". \"/etc/profiles/per-user/\$USER/etc/profile.d/hm-session-vars.sh\"";
}