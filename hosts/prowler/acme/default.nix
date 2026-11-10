{private, ...}: {
  security.acme.certs.internal.domain = "*.${private.domain.internal}";
  security.acme.certs.waste-of-time.domain = "*.${private.domain.waste-of-time}";
}
