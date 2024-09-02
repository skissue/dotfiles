{inputs}: {
  hostname = "prowler";
  profiles.system = {
    user = "root";
    path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.prowler;
  };
}
