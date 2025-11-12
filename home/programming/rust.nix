# Actual Rust tooling (rustc, cargo, etc.) is managed per-project with
# devshells.
{pkgs, ...}: {
  home.packages = with pkgs; [rust-analyzer bacon];
}
