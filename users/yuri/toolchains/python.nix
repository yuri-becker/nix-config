# Module for Python development
{ pkgs, ... }:
{
  programs.pyenv.enable = true;
  home.packages = with pkgs; [
    jetbrains.pycharm-community-bin
  ];
}
