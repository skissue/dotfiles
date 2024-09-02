# Actual Rust tooling (`rustc`, `cargo`, etc.) is managed per-project with
# devshells.
{pkgs, ...}: {
  home.packages = with pkgs; [rust-analyzer bacon mold];

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    rustflags = ["-C", "link-arg=-fuse-ld=mold"]
  '';
}
