{ pkgs, ... }:
{
  services.tldr-update.enable = true;
  home.packages = with pkgs; [ tlrc ];
}
