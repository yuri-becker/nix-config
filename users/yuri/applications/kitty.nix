{ pkgs, lib, ... }:
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
      size = 20;
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
      hide_window_decorations = false;
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
      shell = "zsh -c ${pkgs.fish}/bin/fish";
      editor = "${pkgs.helix}/bin/hx";
      term = "xterm";

      # OS-specific
      macos_option_as_alt = true;
      macos_quit_when_last_window_closed = true;
      macos_window_resizable = true;
      macos_show_window_title_in = "window";
      macos_menubar_title_max_length = -1;
    };
    keybindings = {
      "shift+cmd+up" = "no_op";
      "shift+cmd+down" = "no_op";
      "cmd+t" = "new_tab_with_cwd";
      "cmd+enter" = "new_window_with_cwd";
      "cmd+w" = "close_window_with_confirmation ignore-shell";
      "cmd+." = "layout_action bias 20 50 70";
      "shift+cmd+." = "toggle_layout stack";
      "cmd+]" = "next_window";
      "cmd+[" = "prev_window";
      "cmd+n" = "no_op";
    };
    extraConfig = theme;
  };
  xdg.configFile."kitty/kitty.app.png" = {
    source = kittyIcon;
    onChange =
      if pkgs.stdenv.isDarwin then
        "/opt/homebrew/bin/fileicon set \"${pkgs.kitty}/Applications/kitty.app\" \"${kittyIcon}\""
      else
        null;
  };
}
