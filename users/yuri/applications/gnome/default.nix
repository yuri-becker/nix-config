{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./clipboard.nix
    ./dock.nix
    ./keybindings.nix
    ./notifications.nix
    ./top-bar.nix
    ./theme.nix
  ];
  config = lib.mkIf config.localhost.gnome.enable {
    programs.gnome-shell = {
      enable = true;
    };
    home.packages = with pkgs; [
      gnome-calendar
      gnome-tweaks
    ];
  };
}
