{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = with lib; {
    gnome.enable = mkEnableOption "gnome configuration";
  };
  imports = [
    ./clipboard.nix
    ./dock.nix
    ./keybindings.nix
    ./top-bar.nix
    ./theme.nix
  ];
  config = lib.mkIf config.gnome.enable {
    programs.gnome-shell = {
      enable = true;
    };
    home.packages = with pkgs; [
      gnome-calendar
      gnome-tweaks
    ];
  };
}
