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
      extraCompatPackages = with pkgs; [proton-ge-bin steamtinkerlaunch];
    };
    gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    gamescope = {
      enable = true;
      package = pkgs.gamescope_git;
    };
  };
}
