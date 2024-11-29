{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.enableGaming = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Enable gaming-related software";
  };
  config = lib.mkMerge [
    (lib.mkIf config.my.enableGaming {
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
    })
    {
      specialisation.no-gaming.configuration = {
        my.enableGaming = false;
      };
    }
  ];
}
