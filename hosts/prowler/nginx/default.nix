{
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };

  security.acme.defaults.group = "nginx";
}
