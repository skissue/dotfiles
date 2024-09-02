{
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.services.minecraft-servers;
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.minecraft = {
      enable = true;
      package = inputs.nix-minecraft.packages.${pkgs.system}.paper-server;
      jvmOpts = "-Xms2G -Xmx2G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
      serverProperties = {
        difficulty = "hard";
        spawn-protection = 0;
        motd = "<3";
      };
    };
  };
  
  environment.persistence."/data".directories = [
    {
      directory = "${cfg.dataDir}/minecraft";
      user = cfg.user;
      group = cfg.group;
      mode = "770";
    }
  ];

  # For socket
  my.user.extraGroups = ["minecraft"];
}
