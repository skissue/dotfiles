{
  config,
  pkgs,
  inputs,
  ...
}: let
  user = config.users.users.${config.my.user.name};
in {
  environment.systemPackages = with pkgs; [
    # For `git-annex-shell`.
    git-annex
    # `git-annex` complains if it's not present.
    inputs.git-annex-backend-XBLAKE3.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Otherwise Git complains when trying to make commits on the tracking branch
  # (I think).
  programs.git.config = {
    user = {
      name = "Ad";
      email = "ad@prowler.adtailnet";
    };
  };

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
