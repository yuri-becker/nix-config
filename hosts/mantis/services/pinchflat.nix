{
  lib,
  config,
  pkgs,
  ...
}:
let
  domain = "yt.home.arpa";
  navidromeDomain = "asmr.home.arpa";
  sopsFile = ./pinchflat.secrets.yaml;
  tagAsmrFiles =
    with pkgs;
    writeScriptBin "tag-asmr-files" ''
      #!${fish}/bin/fish
      argparse 'media=' -- $argv; or return 1

      set -l temp (mktemp -d)

      for folder in $_flag_media/*
          set -l artist (basename $folder)
          echo "Going through $artist"
          set -l track 1
          for file in (ls $folder | sort -r)
              ${tageditor}/bin/tageditor set album="$artist" albumartist="$artist" track=$track artist="$artist" --quiet --temp-dir "$temp" -f "$folder/$file"
              set track (math $track + 1)
          end
      end
    '';
in
{
  environment.systemPackages = [ tagAsmrFiles ];
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

  systemd.timers."tag-asmr-files" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "tag-asmr-files.service";
    };
  };
  systemd.services."tag-asmr-files" = {
    serviceConfig = {
      Type = "simple";
      User = config.services.pinchflat.user;
      ExecStart = "${tagAsmrFiles}/bin/tag-asmr-files --media ${config.services.pinchflat.mediaDir}";
    };
  };
}
