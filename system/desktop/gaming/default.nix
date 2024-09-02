{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraLibraries = ps:
          with ps; [
            gamemode
          ];
      };
    };
    gamemode.enable = true;
  };
}
