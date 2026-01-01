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
  config = lib.mkIf config.gnome.enable {
    programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [ { package = pano; } ];
    dconf.settings = {
      "${namespace}" = {
        active-item-border-color = "rgb(129,61,156)";
        history-length = 100;
        hovered-item-border-color = "rgb(129,61,156)";
        keep-search-entry = false;
        link-previews = false;
        paste-on-select = false;
        play-audio-on-copy = false;
        send-notification-on-copy = false;
        session-only-mode = true;
        window-position = 0;
      };
      "${namespace}/emoji-item" = item-colors;
      "${namespace}/file-item" = item-colors;
      "${namespace}/link-item" = item-colors;
      "${namespace}/text-item" = item-colors;
    };
  };
}
