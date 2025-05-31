{
  services.nginx.virtualHosts."notes.adtailnet".locations."/" = {
    root = "/etc/notes";
    extraConfig = ''
      allow 100.69.0.7 ;
      allow fd7a:115c:a1e0::4 ;
      allow 100.69.0.9 ;
      allow fd7a:115c:a1e0::2 ;
      allow 100.69.0.10 ;
      allow fd7a:115c:a1e0::13 ;
      allow 100.69.0.20 ;
      allow fd7a:115c:a1e0::14 ;
      deny  all ;

      autoindex on;
    '';
  };
}
