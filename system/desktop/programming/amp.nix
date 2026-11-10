{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Faster-updating versions
  nixpkgs.overlays = [inputs.amp.overlays.default];

  users.users.${config.my.user.name}.packages = with pkgs; [
    amp-cli
    amp-desktop
  ];
}
