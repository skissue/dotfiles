{inputs, ...}: {
  imports = [inputs.chaotic.nixosModules.default];

  chaotic.mesa-git.enable = true;
}
