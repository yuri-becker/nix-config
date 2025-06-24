{ pkgs, ... }:
{
  home.packages = with pkgs; [ just ];
  programs.fish.shellAbbrs.j = "just";
}
