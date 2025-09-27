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
    CARGO_HOME = "${dataDir}/cargo";
    CUDA_CACHE_PATH = "${cacheDir}/nv";
    DUB_HOME = "${dataDir}/dub";
    GNUPGHOME = "${dataDir}/gnupg";
    GOPATH = "${dataDir}/go";
    GRADLE_USER_HOME = "${dataDir}/gradle";
    HISTFILE = "${stateDir}/bash/history";
    KERAS_HOME = "${dataDir}/keras";
    NODE_REPL_HISTORY = "${stateDir}/node_repl_history";
    WINEPREFIX = "${dataDir}/wine";
    XCOMPOSECACHE = "${cacheDir}/X11/xcompose";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configDir}/java";
  };

  home.packages = [pkgs.xdg-utils];
}
