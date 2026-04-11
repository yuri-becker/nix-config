{
  lib,
  config,
  pkgs,
  ...
}:
let
  domain = "yt.home.arpa";
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

  backup-dirs = [
    config.services.pinchflat.mediaDir
  ];
  homer.links = [
    {
      name = "Pinchflat";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/pinchflat.png";
      url = "https://yt.home.arpa";
    }
  ];

  systemd.timers."tag-asmr-files" = {
    enable = false; # Temporarily disabled
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
