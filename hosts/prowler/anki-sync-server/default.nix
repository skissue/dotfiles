{
  lib,
  pkgs,
  ...
}: let
  dataDir = "/var/lib/anki-sync-server";
in {
  users.users.anki-sync-server = {
    isSystemUser = true;
    group = "anki-sync-server";
    home = dataDir;
    createHome = true;
  };
  users.groups.anki-sync-server = {};

  systemd.services.anki-sync-server = {
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    description = "Anki Sync Server";
    environment = {
      SYNC_BASE = dataDir;
      PASSWORDS_HASHED = "1";
      SYNC_USER1 = "ad:$pbkdf2-sha256$i=600000,l=32$4jp0QwZOU7jgA6QHqAXUuQ$m6wo09xrc+40PfUVdbbe02Cv1WQYLsDswy5sdYX+u0E";
    };
    serviceConfig = {
      User = "anki-sync-server";
      Group = "anki-sync-server";
      WorkingDirectory = dataDir;
      ExecStart = lib.getExe pkgs.anki-sync-server;
    };
  };
}
