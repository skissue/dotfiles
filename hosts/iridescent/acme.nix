{private, ...}: {
  security.acme.certs.wasteoftime.domain = "*.${private.domain.wasteoftime}";
}
