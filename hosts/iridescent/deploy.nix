{inputs, ...}: {
  hostname = "iridescent";
  profiles.system = {
    user = "root";
    path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.iridescent;
  };
  # TODO Make this the default everywhere.
  interactiveSudo = true;
}
