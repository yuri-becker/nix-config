{ config, ... }:
let
  domain = "spools.home.arpa";
in
{
  services.spoolman.enable = true;

  services.caddy.virtualHosts."${domain}".extraConfig =
    "reverse_proxy :${toString config.services.spoolman.port}";

  services.caddy.virtualHosts."${domain}:80".extraConfig =
    "reverse_proxy :${toString config.services.spoolman.port}";

  homer.links = [
    {
      name = "Spoolman";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/spoolman.png";
      url = "https://${domain}";
    }
  ];
}
