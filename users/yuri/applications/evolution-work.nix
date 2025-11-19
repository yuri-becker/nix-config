{ pkgs, ... }:
{
  home.packages = [
    pkgs.evolution
  ];
  xdg.autostart.entries = [ "${pkgs.evolution}/share/applications/org.gnome.Evolution.desktop" ];
}
