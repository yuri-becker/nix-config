{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.work.enable {
    home.packages = with pkgs; [ mattermost-desktop ];
    xdg.autostart.entries = [ "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop" ];
  };
}
