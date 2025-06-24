{ config, ... }:
{
  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = 30003;
  };
  services.caddy.virtualHosts."audiobooks.home.arpa".extraConfig =
    "reverse_proxy :${toString config.services.audiobookshelf.port}";
  services.borgmatic.configurations.mantis.source_directories = [
    "/var/lib/${config.services.audiobookshelf.dataDir}"
  ];
}
