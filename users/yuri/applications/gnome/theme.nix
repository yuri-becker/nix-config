{ pkgs, ... }:
let
  themeName = "Nightfox-Dark";
  cursorTheme = "Capitaine Cursors (Palenight) - White";
  iconTheme = "WhiteSur-dark";
in
{
  home.packages = with pkgs; [
    capitaine-cursors-themed
    gtk-engine-murrine
    gnome-themes-extra
    sassc
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
      accent-color = "purple";
      gtk-theme = themeName;
      cursor-theme = cursorTheme;
      icon-theme = iconTheme;
    };
  };

  gtk = {
    enable = true;
    theme.name = themeName;
    iconTheme.name = iconTheme;
    cursorTheme.name = cursorTheme;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.sessionVariables.GTK_THEME = themeName;
}
