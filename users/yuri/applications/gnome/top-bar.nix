{ pkgs, ... }:
{
  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    { package = tophat; }
    { package = todo-list; }
    { package = tracker; }
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      lock-show-date = true;
      clock-show-weekday = true;
    };
  };
}
