{ config, ... }:
let
  sopsFile = ./moonraker.secrets.yaml;
in
{
  sops.secrets."moonraker/hass_token".sopsFile = sopsFile;
  sops.templates."hass.cfg" =
    let
      host = "192.168.0.10";
      port = "80";
      token = config.sops.placeholder."moonraker/hass_token";
    in
    {
      owner = config.services.moonraker.user;
      content = ''
        [power Printer]
        on_when_job_queued: True
        locked_while_printing: True
        restart_klipper_when_powered: True
        off_when_shutdown: True
        off_when_shutdown_delay: 30
        type: homeassistant
        protocol: http
        address: ${host}
        port: ${port}
        domain: switch
        device: switch.sv06
        token: ${token}

        [notifier homeassistant]
        url: hassio://${host}/${token}?port=${port}
        events: complete,error
      '';
    };
  services.moonraker =
    let
      klipper = config.services.klipper;
    in
    {
      enable = true;
      allowSystemControl = true;
      group = klipper.group;
      settings = {
        server = {
          max_upload_size = 5000;
        };
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
        "include ${config.sops.templates."hass.cfg".path}" = { };
      };
    };

  networking.firewall.allowedTCPPorts = [
    config.services.moonraker.port
  ];
  networking.firewall.allowedUDPPorts = [
    config.services.moonraker.port
  ];
}
