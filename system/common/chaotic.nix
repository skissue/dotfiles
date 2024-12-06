{inputs, ...}: {
  imports = [inputs.chaotic.nixosModules.default];

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
