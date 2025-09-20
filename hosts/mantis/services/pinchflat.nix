{ lib, config, ... }:
let
  domain = "yt.home.arpa";
  navidromeDomain = "asmr.home.arpa";
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

  services.navidrome = {
    enable = true;
    openFirewall = false;
    settings = {
      EnableInsightsCollector = false;
      MusicFolder = config.services.pinchflat.mediaDir;
      BaseUrl = "https://${navidromeDomain}";
      Agents = "";
      CoverArtPriority = "embedded";
      Deezer.Enabled = false;
      DataFolder = "/var/lib/navidrome/";
      EnableExternalServices = false;
      EnableNowPlaying = false;
      LastFM.Enabled = false;
      ListenBrainz.Enabled = false;
      PID.Album = "folder";
    };
  };

  services.caddy.virtualHosts."${navidromeDomain}".extraConfig =
    "reverse_proxy :${toString config.services.navidrome.settings.Port}";

  services.borgmatic.configurations.mantis.source_directories = [
    config.services.pinchflat.mediaDir
    config.services.navidrome.settings.DataFolder
  ];
  homer.links = [
    {
      name = "ASMR";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/navidrome.png";
      url = "https://asmr.home.arpa";
    }
    {
      name = "Pinchflat";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/pinchflat.png";
      url = "https://yt.home.arpa";
    }
  ];
}
