{ pkgs, ... }:
let
  themeName = "Nightfox";
in
{
  programs.gnome-shell.theme = {
    name = themeName;
    package = pkgs.nightfox-gtk-theme;
  };
  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.sessionVariables.GTK_THEME = themeName;
}
