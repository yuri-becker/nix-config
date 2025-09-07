{ lib, config, ... }:
let
  domain = "yt.home.arpa";
  sopsFile = ./pinchflat.secrets.yaml;
in
{
  sops.secrets."pinchflat/secret_key_base".sopsFile = sopsFile;
  sops.templates."pinchflat-secrets.env" = {
    content = lib.generators.toKeyValue { } {
      SECRET_KEY_BASE = config.sops.placeholder."pinchflat/secret_key_base";
    };
  };
  services.pinchflat = {
    enable = true;
    openFirewall = false;
    secretsFile = config.sops.templates."pinchflat-secrets.env".path;
  };
  services.caddy.virtualHosts."${domain}".extraConfig =
    "reverse_proxy :${toString config.services.pinchflat.port}";
  services.borgmatic.configurations.mantis.source_directories = [
    config.services.pinchflat.mediaDir
  ];

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      media_dir = [ "A,${config.services.pinchflat.mediaDir}" ];
      friendly_name = "ASMR Stash";
      notify_interval = 30;
    };
  };
}
