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
      themePkg
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
      colorScheme = "dark";
      iconTheme = {
        name = "WhiteSur-purple-dark";
        package = pkgs.whitesur-icon-theme.override { themeVariants = [ "purple" ]; };
      };
      gtk4.theme = config.gtk.theme;
    };

    dconf.settings = {
      "org/gnome/shell/extensions/user-theme" = {
        name = themeName;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        accent-color = "purple";
        document-font-name = "${config.localhost.font.system.name} 12";
        font-name = "${config.localhost.font.system.name} 12";
        gtk-theme = themeName;
        cursor-size = 32;
        cursor-theme = "phinger-cursors-light";
        icon-theme = iconTheme;
        monospace-font-name = "${config.localhost.font.mono.name} 12";
      };
    };
    home.sessionVariables.GTK_THEME = themeName;
  };
}
