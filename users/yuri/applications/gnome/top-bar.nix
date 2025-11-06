{ pkgs, ... }:
{
  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    { package = tophat; }
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      lock-show-date = true;
      clock-show-weekday = true;
    };
  };
}
