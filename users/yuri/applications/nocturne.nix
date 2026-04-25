{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    services.flatpak = {
      enable = lib.mkDefault true;
      packages = [ "com.jeffser.Nocturne" ];
    };

    # home.file.".var/app/com.jeffser.Nocturne/config/glib-2.0/settings/keyfile".text = ''
    #   [com/jeffser/Nocturne]
    #   integration-library-dir='${config.home.homeDirectory}/Music'
    #   selected-instance-type='NocturneIntegrationNavidrome'
    #   integration-ip='https://music.catboy.house'
    #   integration-user='yuri'
    #   integration-trust-server=false
    #   volume=1.0
    #   default-page-tag='home'
    #   visualizer-manual-color='0.11,0.44,0.85'
    #   player-dynamic-bg-mode='blur'
    #   show-visualizer=true
    #   visualizer-type='wave'
    #   default-width=1152
    #   default-height=682
    #   use-big-footer=true
    #   player-blur-bg=false
    #   auto-play=false
    # '';
  };
}
