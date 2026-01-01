{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gnome.enable {
    programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [ { package = dash-to-dock; } ];
  };
}
