{
  config,
  pkgs,
  ...
}: {
  users.users.${config.my.user.name}.packages = with pkgs; [nil alejandra];
}
