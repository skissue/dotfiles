{pkgs, ...}: {
  imports = [./fonts ./gaming ./greetd ./hyprland ./pipewire];

  services.logind.powerKey = "suspend";

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Emacs ispell
  environment.wordlist.enable = true;

  # `man -k` and other manual searchers (like Emacs)
  documentation.man.generateCaches = true;
}
