{
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFile = ./streamrip.secrets.yaml;
  secrets = {
    qobuz.userid = "streamrip/qobuz/userid";
    qobuz.token = "streamrip/qobuz/token";
    qobuz.app_id = "streamrip/qobuz/app_id";
    qobuz.secrets = "streamrip/qobuz/secrets";
  };
  template = "streamrip.toml";
  targetFile = ".config/streamrip/config.toml";
in
{
  config = lib.mkIf config.localhost.enable {
    home.packages = [ pkgs.streamrip ];
    sops.secrets = lib.genAttrs (builtins.attrValues secrets.qobuz) (_: {
      inherit sopsFile;
    });

    home.file."${targetFile}.orig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates.${template}.path}";
      recursive = true;
      onChange = ''
        cp $HOME/${targetFile}.orig $HOME/${targetFile}
        chmod 600 $HOME/${targetFile}
      ''; # Streamrip wants a writable file
    };

    # See https://github.com/nathom/streamrip/blob/dev/streamrip/config.toml
    sops.templates."${template}".content = ''
      [downloads]
      folder = "${config.home.homeDirectory}/Downloads"
      source_subdirectories = false
      disc_subdirectories = true
      concurrency = true
      max_connections = 2
      requests_per_minute = 60
      verify_ssl = true

      [qobuz]
      quality = 4
      download_booklets = true
      use_auth_token = true
      email_or_userid = "${config.sops.placeholder.${secrets.qobuz.userid}}"
      password_or_token = "${config.sops.placeholder.${secrets.qobuz.token}}"
      app_id = "${config.sops.placeholder.${secrets.qobuz.app_id}}"
      secrets = ${config.sops.placeholder.${secrets.qobuz.secrets}}

      [tidal]
      quality = 3
      download_videos = false
      user_id = ""
      country_code = ""
      access_token = ""
      refresh_token = ""
      token_expiry = ""

      [deezer]
      quality = 2
      lower_quality_if_not_available = true
      arl = ""
      use_deezloader = true
      deezloader_warnings = true

      [soundcloud]
      quality = 0
      client_id = ""
      app_version = ""

      [youtube]
      quality = 0
      download_videos = false
      video_downloads_folder = "/dev/null"

      [database]
      downloads_enabled = false
      downloads_path = "/dev/null"
      failed_downloads_enabled = true
      failed_downloads_path = "/dev/null"

      [conversion]
      enabled = false
      codec = "ALAC"
      sampling_rate = 48000
      bit_depth = 24
      lossy_bitrate = 320

      [qobuz_filters]
      extras = false
      repeats = false
      non_albums = false
      features = false
      non_studio_albums = false
      non_remaster = false

      [artwork]
      embed = true
      embed_size = "large"
      embed_max_width = -1
      save_artwork = true
      saved_max_width = -1

      [metadata]
      set_playlist_to_album = true
      renumber_playlist_tracks = true
      exclude = []

      [filepaths]
      add_singles_to_folder = false
      folder_format = "{albumartist} - {title} ({year})"
      track_format = "{tracknumber:02}. - {artist} - {title}"
      restrict_characters = false
      truncate_to = 120

      [lastfm]
      source = "qobuz"
      fallback_source = ""

      [cli]
      text_output = true
      progress_bars = true
      max_search_results = 100

      [misc]
      version = "2.2.0"
      check_for_updates = false
    '';

    programs.fish.shellAbbrs = {
      "rip-album" = "${lib.getExe pkgs.streamrip} search qobuz album";
    };
  };
}
