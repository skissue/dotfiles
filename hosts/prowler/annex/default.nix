{
  config,
  pkgs,
  ...
}: let
  user = config.users.users.${config.my.user.name};
in {
  # For `git-annex-shell`.
  environment.systemPackages = with pkgs; [git-annex];

  # Data here (presumably) gets backed up from other places, so leave it in
  # local.
  my.persist.local.directories = [
    {
      directory = "/etc/theuniverse";
      user = user.name;
      group = user.group;
      mode = "700";
    }
  ];
}
