{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.nix-monitored.overlays.default
    (self: super: {
      nix-direnv = super.nix-direnv.override {
        nix = self.nix-monitored;
      };
    })
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
