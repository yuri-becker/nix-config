{
  config,
  lib,
  pkgs,
  ...
}:
let
  themePkg = pkgs.nightfox-gtk-theme.override {
    colorVariants = [ "dark" ];
    themeVariants = [ "purple" ];
    sizeVariants = [ "standard" ];
    tweakVariants = [ "black" ];
  };
  themeName = config.gtk.theme.name;
  cursorTheme = "Capitaine Cursors (Palenight) - White";
  iconTheme = config.gtk.iconTheme.name;
in
{
  config = lib.mkIf config.localhost.gnome.enable {
    home.packages = with pkgs; [
      gtk-engine-murrine
      gnome-themes-extra
      sassc
    ];
    programs.gnome-shell.theme = {
      name = themeName;
      package = themePkg;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Nightfox-Purple-Dark";
        package = themePkg;
      };
      iconTheme = {
        name = "WhiteSur-purple-dark";
        package = pkgs.whitesur-icon-theme.override { themeVariants = [ "purple" ]; };
      };
      cursorTheme = {
        name = "Capitaine Cursors (Palenight) - White";
        package = pkgs.capitaine-cursors-themed;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    dconf.settings = {
      "org/gnome/shell/extensions/user-theme" = {
        name = themeName;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = "purple";
        gtk-theme = themeName;
        cursor-theme = cursorTheme;
        icon-theme = iconTheme;
      };
    };

    home.sessionVariables.GTK_THEME = themeName;
  };
}
