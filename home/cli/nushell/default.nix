{lib, ...}: {
  programs.nushell = {
    enable = true;
    # Needs to be after sourcing tools (carapace, zoxide, etc.)
    extraConfig = lib.mkAfter (builtins.readFile ./config.nu);
    extraEnv = ''
      $env.SHELL = (which nu | get path.0)
    '';
  };
  programs.carapace.enable = true;
}
