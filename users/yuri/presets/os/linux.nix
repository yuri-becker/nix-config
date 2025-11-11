# Config file for linux systems
{ config, pkgs, ... }:
{
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  home.packages = with pkgs; [
    wl-clipboard
  ];
}
