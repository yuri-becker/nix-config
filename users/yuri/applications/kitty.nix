{ pkgs, ... }:
let
  theme = builtins.readFile (
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/kitty/b14e8385c827f2d41660b71c7fec1e92bdcf2676/themes/mocha.conf";
      sha256 = "92fcdd01c33e64243fbba4bb6af4b88877769432b0bffe862cf88de80e909524";
    }
  );
  kittyIcon = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/k0nserv/kitty-icon/main/src/neue_outrun/icon_512x512.png";
    sha256 = "0932w14hi3zfhxljazqdsg4zddzgl2jw6ycd95fwmhbirab4kdas";
  };
in
{
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [ "--start-as fullscreen --single-instance" ];
    font = {
      name = "MesloLGS Nerd Font";
      package = pkgs.meslo-lgs-nf;
      size = if pkgs.stdenv.isDarwin then 20 else 18;
    };
    settings = {
      # Font
      modify_font = "cell_height +2px";
      cursor_shape = "underline";

      # Remote Control
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty-socket";

      # Cursor
      cursor_underline_thickness = 4.0;
      cursor_blink_interval = 0.67;

      # Scrollback
      scrollback_lines = -1;
      touch_scroll_multiplier = 1.4;

      # Mouse
      url_color = "#F5C2E7";
      url_style = "double";
      show_hyperlink_targets = true;
      strip_trailing_spaces = "smart";
      focus_follows_mouse = true;

      # Bell
      enable_audio_bell = false;
      visual_bell_duration = 0.5;
      visual_bell_color = "black";
      window_alert_on_bell = true;

      # Window
      enabled_layouts = "tall:bias=70,stack";
      hide_window_decorations = if pkgs.stdenv.isDarwin then false else true;
      resize_in_steps = false;
      window_margin_width = 0;
      window_border_width = "1pt";
      window_padding_width = 1;
      draw_minimal_borders = false;

      # Tab Bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = 2;
      tab_powerline_style = "slanted";
      tab_activity_symbol = "✨";
      tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{fmt.bold}{index} {fmt.nobold}{title}";

      # Advanced
      shell = "$SHELL -c ${pkgs.fish}/bin/fish";
      editor = "${pkgs.helix}/bin/hx";
      term = "xterm";

      # OS-specific
      macos_option_as_alt = true;
      macos_quit_when_last_window_closed = true;
      macos_window_resizable = true;
      macos_show_window_title_in = "window";
      macos_menubar_title_max_length = -1;
      wayland_titlebar_color = "background";
    };
    keybindings = {
      # Unbinds
      "shift+super+up" = "no_op";
      "shift+super+down" = "no_op";
      "shift+ctrl+up" = "no_op";
      "shift+ctrl+down" = "no_op";
      "super+n" = "no_op";
      "ctrl+shift+f11" = "no_op";
      "ctrl+cmd+f" = "no_op";
      "ctrl+shift+f10" = "no_op";
      "ctrl+tab" = "no_op";
      "cmd+," = "no_op";
      "ctrl+shift+f2" = "no_op";
      "ctrl+shift+escape" = "no_op";
      "ctrl+shift+a>m" = "no_op";
      "ctrl+shift+a>l" = "no_op";
      "cmd+h" = "no_op";
      # Clipboard
      "super+c" = "copy_to_clipboard";
      "super+v" = "paste_from_clipboard";
      # Windows
      "super+enter" = "new_window_with_cwd";
      "super+w" = "close_window_with_confirmation ignore-shell";
      "super+." = "layout_action bias 20 50 70";
      "shift+super+." = "toggle_layout stack";
      "super+]" = "next_window";
      "super+[" = "prev_window";
      # Tabs
      "super+shift+]" = "next_tab";
      "super+shift+[" = "previous_tab";
      "super+t" = "new_tab_with_cwd";
    };
    extraConfig = theme;
  };
  xdg.configFile."kitty/kitty.app.png" = {
    source = kittyIcon;
    onChange =
      if pkgs.stdenv.isDarwin then
        "/opt/homebrew/bin/fileicon set \"${pkgs.kitty}/Applications/kitty.app\" \"${kittyIcon}\""
      else
        "";
  };
}
