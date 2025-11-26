{ pkgs, ... }:
{
  imports = [
    ./clipboard.nix
    ./dock.nix
    ./top-bar.nix
    ./theme.nix
  ];
  programs.gnome-shell = {
    enable = true;
  };
  home.packages = with pkgs; [
    gnome-calendar
    gnome-tweaks
  ];
}
