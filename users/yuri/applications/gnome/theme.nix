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
  fonts = {
    interface = "Aleo";
    document = "Aleo";
    monospace = "Geist Mono";
  };
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
    home.file.".local/share/themes/Nightfox-custom/gnome-shell/gnome-shell.css".text = ''
      @import url(${themePkg}/share/themes/${themeName}/gnome-shell/gnome-shell.css);
    '';
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
        document-font-name = "${fonts.interface} 12";
        font-name = "${fonts.interface} 12";
        gtk-theme = themeName;
        cursor-size = 32;
        cursor-theme = "phinger-cursors-light";
        icon-theme = iconTheme;
        monospace-font-name = "${fonts.monospace} 12";
      };
    };

    home.sessionVariables.GTK_THEME = themeName;

    programs.kitty.font = {
      name = "family='${fonts.monospace}' variable_name=GeistMono wght=517";
      size = if pkgs.stdenv.isDarwin then 20 else 18;
    };
  };
}
