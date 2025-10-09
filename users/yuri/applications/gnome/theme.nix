{ pkgs, ... }:
let
  themeName = "Nightfox-Dark";
in
{
  home.packages = with pkgs; [
    capitaine-cursors-themed
    gtk-engine-murrine
    nightfox-gtk-theme
    whitesur-icon-theme
  ];
  programs.gnome-shell.theme = {
    name = themeName;
    package = pkgs.nightfox-gtk-theme;
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = themeName;
    };
  };

  gtk = {
    enable = true;
    theme.name = themeName;
    iconTheme.name = "WhiteSur-dark";
    cursorTheme.name = "Capitaine Cursors (Palenight) - White";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.sessionVariables.GTK_THEME = themeName;
}
