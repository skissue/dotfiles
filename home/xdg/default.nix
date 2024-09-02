{
  config,
  pkgs,
  ...
}: let
  vars = config.home.sessionVariables;
  stateDir = vars.XDG_STATE_HOME;
  dataDir = vars.XDG_DATA_HOME;
  configDir = vars.XDG_CONFIG_HOME;
  cacheDir = vars.XDG_CACHE_HOME;
in {
  xdg.enable = true;
  xdg.mimeApps.enable = true;
  home.preferXdgDirectories = true;

  home.sessionVariables = {
    HISTFILE = "${stateDir}/bash/history";
    CARGO_HOME = "${dataDir}/cargo";
    GNUPGHOME = "${dataDir}/gnupg";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configDir}/java";
    CUDA_CACHE_PATH = "${cacheDir}/nv";
    GOPATH = "${dataDir}/go";
    GRADLE_USER_HOME = "${dataDir}/gradle";
    KERAS_HOME = "${dataDir}/keras";
    WINEPREFIX = "${dataDir}/wine";
  };

  home.packages = [pkgs.xdg-utils];
}
