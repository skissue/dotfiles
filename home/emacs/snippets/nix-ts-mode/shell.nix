# -*- mode: snippet -*-
# name: shell.nix
# --
{pkgs ? import <nixpkgs> {}}:

with pkgs;

mkShell {
  ${1:nativeBuildInputs = [$2];}
  ${3:buildInputs = [$4];}
  ${5:shellHook = ''
    $6
  '';}
}