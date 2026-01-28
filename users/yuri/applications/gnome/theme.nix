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
  iconTheme = config.gtk.iconTheme.name;
in
{
  config = lib.mkIf config.localhost.gnome.enable {
    home.packages = with pkgs; [
      gtk-engine-murrine
      gnome-themes-extra
      phinger-cursors
      sassc
    ];
    programs.gnome-shell.theme = {
      name = themeName;
      package = themePkg;
    };
    home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light";

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
        cursor-size = 32;
        cursor-theme = "phinger-cursors-light";
        icon-theme = iconTheme;
      };
    };

    home.sessionVariables.GTK_THEME = themeName;
  };
}
