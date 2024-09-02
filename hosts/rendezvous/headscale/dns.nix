{config, ...}: let
  base = config.services.headscale.settings.dns_config.base_domain;
in {
  services.headscale.settings.dns_config.extra_records = [
    {
      name = "notify.${base}";
      type = "AAAA";
      value = "fd7a:115c:a1e0::1";
    }
    {
      name = "notify.${base}";
      type = "A";
      value = "100.69.0.8";
    }
    {
      name = "media.${base}";
      type = "A";
      value = "100.69.0.14";
    }
    {
      name = "media.${base}";
      type = "AAAA";
      value = "fd7a:115c:a1e0::e";
    }
    {
      name = "matrix.${base}";
      type = "A";
      value = "100.69.0.14";
    }
    {
      name = "matrix.${base}";
      type = "AAAA";
      value = "fd7a:115c:a1e0::e";
    }
  ];
}
