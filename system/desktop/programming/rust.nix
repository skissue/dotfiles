# Actual Rust tooling (rustc, cargo, etc.) is managed per-project with
# devshells.
{
  config,
  pkgs,
  ...
}: {
  users.users.${config.my.user.name}.packages = with pkgs; [rust-analyzer bacon];
}
