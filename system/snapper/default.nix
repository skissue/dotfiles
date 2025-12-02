{config, ...}: let
  user = config.my.user.name;
in {
  services.snapper.configs = {
    local = {
      SUBVOLUME = "/local";
      # ALLOW_USERS = [user];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
    data = {
      SUBVOLUME = "/data";
      # ALLOW_USERS = [user];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
  };
}
