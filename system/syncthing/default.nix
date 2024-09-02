# "there is nothing more permanent than a temporary hack"
{
  config,
  lib,
  ...
}: let
  cfg = config.services.syncthing;
  dataDir = cfg.dataDir;
  devices = {
    windstorm = "JUN5WSP-ZWFSABW-EX3N2D7-YSCCGH5-JPLBH6C-NUJGCQM-5IYWIPD-ZXZP7QK";
    flashpoint = "CHARWJN-XIL4STX-477CDS3-JC5OYFM-CT6U2QI-MQOIRD3-62S4EEH-D2BB7Q5";
    nightcrawler = "XBNJIVW-7ZFRDM2-ESYJXZH-A4XBR2T-QLP4QL3-QTRGKMU-6Z37NDG-D7NJOAY";
    prowler = "MFHRVFK-TCKBT2Y-OTE7KEU-3T5FG6O-3266K6T-2MZ37Q5-V3RTDRQ-P3EKSQG";
  };
in {
  services.syncthing = {
    enable = true;
    user = lib.mkDefault config.my.user.name;
    dataDir = lib.mkDefault config.users.users.${config.my.user.name}.home;
    settings = {
      gui.apikey = "iPy5Nbp6JFhjPcECDTAvfxhuabgjjVQU";
      # Merge ID with addresses using hostname, resolves with Tailscale
      devices =
        builtins.mapAttrs (host: id: {
          inherit id;
          addresses = ["tcp://${host}:22000"];
        })
        devices;
      folders = {
        logseq = {
          devices = ["windstorm" "flashpoint"];
          path = "${dataDir}/logseq";
        };
        obsidian = {
          devices = ["windstorm" "flashpoint" "nightcrawler"];
          path = "${dataDir}/obsidian";
        };
        org = {
          devices = ["windstorm" "flashpoint" "nightcrawler" "prowler"];
          path = "${dataDir}/org";
        };
        denote = {
          devices = ["windstorm" "flashpoint" "nightcrawler" "prowler"];
          path = "${dataDir}/denote";
        };
      };
      # Using Tailscale instead
      globalAnnounceEnabled = false;
      localAnnounceEnabled = false;
      relaysEnabled = false;
    };
  };

  my.persist.local.directories = [
    {
      directory = cfg.configDir;
      user = cfg.user;
      group = cfg.group;
    }
  ];
  my.persist.data.directories = map (f: {
    directory = f.value.path;
    user = cfg.user;
    group = cfg.group;
    mode = "700";
  }) (lib.attrsToList cfg.settings.folders);
}
