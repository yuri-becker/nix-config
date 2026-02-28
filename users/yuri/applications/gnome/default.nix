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
      gnome-calculator
      gnome-calendar
      gnome-maps
      gnome-system-monitor
      gnome-tweaks
      nautilus
      papers
      simple-scan
    ];

    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = alphabetical-app-grid; }
        { package = app-hider; }
        { package = clipboard-history; }
        { package = color-picker; }
        { package = dash-to-dock; }
        { package = grand-theft-focus; }
        { package = next-up; }
        { package = notification-counter; }
        { package = quick-settings-tweaker; }
        { package = tophat; }
        { package = uxplay-control; }
      ];
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        lock-show-date = true;
        clock-show-weekday = true;
      };
      "org/gnome/desktop/wm/keybindings" = {
        minimize = [ ];
        move-to-workspace-1 = [ ];
        move-to-workspace-last = [ ];
        panel-run-dialog = [ "<Super>F2" ];
        switch-applications = [ ];
        switch-applications-backward = [ ];
        switch-group = [ ];
        switch-group-backward =[ ];
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
        switch-to-workspace-1 = [ ];
        switch-to-workspace-last = [ ];
        switch-to-workspace-left = [ ];
        switch-to-workspace-right = [ ];
        switch-windows = [ "<Super>Tab" ];
        switch-windows-backward = [ "<Shift><Super>Tab" ];
        toggle-fullscreen = [ "<Shift><Super>backslash" ];
        toggle-maximized = [ "<Super>backslash" ];
        unmaximize = [ ];
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false;
        speed = 0.15384615384615374;
      };

      "org/gnome/shell" = {
        disable-extension-version-validation = true;
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
              "TeamSpeak.desktop"
              "steam.desktop"
            ]
          else if config.localhost.personal.enable then
            [
              "fastmail.desktop"
              "vesktop.desktop"
              "beepertexts.desktop"
              "TeamSpeak.desktop"
              "dev.zed.Zed.desktop"
            ]
          else
            [ ]
        );
      };

      "org/gnome/shell/keybindings" = {
        screenshot = [ ];
        screenshot-window = [ "<Shift><Super>t" ];
        show-screen-recording-ui = [ ];
        show-screenshot-ui = [ "<Super>t" ];

        toggle-message-tray = [ "<Super>r" ];
        toggle-overview = [
          "Tools" # F13
          "<Control>Up"
        ];
      };

      "org/gnome/gnome-system-monitor" = {
        show-dependencies = true;
        show-whose-processes = "all";
      };
      "org/gnome/gnome-system-monitor/proctree" = {

        col-1-visible = true;
        col-10-visible = true;
        col-18-visible = true;
        col-22-visible = true;
        col-24-visible = true;
        col-25-visible = true;
        col-26-visible = false;
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

      "org/gnome/shell/extensions/quick-settings-tweaks" = {
        datemenu-hide-left-box = false;
        dnd-quick-toggle-enabled = false;
        media-enabled = false;
        menu-animation-enabled = false;
        notifications-enabled = false;
        overlay-menu-enabled = false;
        system-items-layout-enabled = true;
        system-items-layout-hide = false;
        system-items-layout-hide-lock = true;
        unsafe-quick-toggle-enabled = false;
        volume-mixer-menu-enabled = false;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [ ];
        help = [ ];
        home = [ "<Super>e" ];
        logout = [ ];
        magnifier = [ ];
        magnifier-zoom-in = [ ];
        magnifier-zoom-out = [ ];
        screenreader = [ ];
        screensaver = [ "<Super>d" ];
      };
    };
  };
}
