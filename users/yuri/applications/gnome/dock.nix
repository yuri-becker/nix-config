{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.gnome.enable {
    programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [ { package = dash-to-dock; } ];
    dconf.settings."org/gnome/shell" = {
      favorite-apps = [
        "librewolf.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "dev.zed.Zed.desktop"
        "org.gnome.Calendar.desktop"
        "linphone.desktop"
        "Mattermost.desktop"
        "beepertexts.desktop"
        "feishin.desktop"
      ];
    };
  };
}
