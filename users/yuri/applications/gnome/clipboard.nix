{
  config,
  lib,
  pkgs,
  ...
}:
let
  namespace = "org/gnome/shell/extensions/pano";
  body-bg-color = "rgb(36,31,49)";
  header-bg-color = "rgb(36,31,49)";
  item-colors = { inherit body-bg-color header-bg-color; };
in
{
  config = lib.mkIf config.localhost.gnome.enable {
    programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [ { package = clipboard-history; } ];
    dconf.settings = {
      "org/gnome/shell/extensions/clipboard-history" = {
        cache-only-favorites = true;
        cache-size = 100;
        history-size = 25;
        ignore-password-mimes = false;
        toggle-private-mode = [ ];
        topbar-preview-size = 50;
      };
    };
  };
}
