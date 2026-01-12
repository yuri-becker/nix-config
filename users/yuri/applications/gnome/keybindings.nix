{ config, lib, ... }:
{

  config = lib.mkIf config.localhost.gnome.enable {
    dconf.settings = {
      "org/gnome/shell/keybindings" = {
        screenshot = [ ];
        screenshot-window = [ ];
        show-screen-recording-ui = [ ];
        show-screenshot-ui = [ "<Control><Alt>4" ];
        toggle-message-tray = [ "<Super>u" ];
        toggle-overview = [
          "Tools" # F13
          "<Control>Up"
        ];
      };
    };
  };
}
