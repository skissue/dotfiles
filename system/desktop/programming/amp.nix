{
  config,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.amp-desktop.overlays.default];

  users.users.${config.my.user.name}.packages = with pkgs; [
    amp-cli
    amp-desktop
  ];
}
