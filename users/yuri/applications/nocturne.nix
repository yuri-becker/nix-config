{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [ nocturne ];

    dconf.settings."com/jeffser/Nocturne" = {
      button-size = "big";
      default-page-tag = "home";
      global-dynamic-bg-mode = "gradient";
      integration-ip = "https://music.catboy.house";
      integration-library-dir = "${config.home.homeDirectory}/Music";
      integration-trust-server = false;
      integration-user = "yuri";
      max-bitrate = 0;
      selected-instance-type = "NocturneIntegrationNavidrome";
      show-carousel-pan-buttons = false;
      show-visualizer = true;
      sidebar-disabled-pages = [
        "albums-starred"
        "albums-frequent"
      ];
      use-sidebar-player = true;
      visualizer-auto-color = true;
      visualizer-bar-n = 12;
      visualizer-fill-mode = "translucent";
      visualizer-type = "wave";
    };
  };
}
