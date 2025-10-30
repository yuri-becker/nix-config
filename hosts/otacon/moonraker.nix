{ config, ... }:
{
  services.moonraker =
    let
      klipper = config.services.klipper;
    in
    {
      enable = true;
      allowSystemControl = true;
      group = klipper.group;
      settings = {
        authorization = {
          cors_domains = [
            "https://otacon.home.arpa"
            "http://otacon.local"
          ];
          trusted_clients = [
            "192.168.0.0/16"
            "127.0.0.1"
            "FE80::/10"
            "::1"
          ];
        };
        history = { };
        announcements = {
          subscriptions = [ "mainsail" ];
        };
        spoolman = {
          server = "http://spools.home.arpa";
          sync_rate = 60;
        };
      };
    };

  networking.firewall.allowedTCPPorts = [
    config.services.moonraker.port
  ];
  networking.firewall.allowedUDPPorts = [
    config.services.moonraker.port
  ];
}
