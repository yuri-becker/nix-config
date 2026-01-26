{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./theme.nix ];
  config = lib.mkIf config.localhost.gnome.enable {
    home.packages = with pkgs; [
      gnome-calendar
      gnome-tweaks
    ];

    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = clipboard-history; }
        { package = color-picker; }
        { package = dash-to-dock; }
        { package = grand-theft-focus; }
        { package = next-up; }
        { package = notification-counter; }
        { package = tophat; }
        # { package = user-themes; }
        { package = uxplay-control; }
      ];
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        lock-show-date = true;
        clock-show-weekday = true;
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "librewolf.desktop"
          "kitty.desktop"
          "feishin.desktop"
          "org.gnome.Nautilus.desktop"
        ]
        ++ (
          if config.localhost.work.enable then
            [
              "Mattermost.desktop"
              "beepertexts.desktop"
              "linphone.desktop"
              "org.gnome.Calendar.desktop"
              "dev.zed.Zed.desktop"
            ]
          else if config.localhost.gaming.enable then
            [
              "fastmail.desktop"
              "vesktop.desktop"
              "beepertexts.desktop"
              "steam.desktop"
            ]
          else
            [ ]
        );
      };

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

      "org/gnome/shell/extensions/clipboard-history" = {
        cache-only-favorites = true;
        cache-size = 100;
        history-size = 25;
        ignore-password-mimes = false;
        toggle-private-mode = [ ];
        topbar-preview-size = 50;
      };

      "org/gnome/shell/extensions/tophat" = {
        cpu-display = "numeric";
        fs-display = "chart";
        mem-display = "numeric";
        mount-to-monitor = "/";
        network-usage-unit = "bytes";
        position-in-panel = "right";
        show-disk = true;
        show-fs = false;
        show-net = false;
      };
    };
  };
}
