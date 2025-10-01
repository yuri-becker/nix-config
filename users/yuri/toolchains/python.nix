# Module for Python development
{ pkgs, ... }:
let
  packages = with pkgs; [
    jetbrains.pycharm-community-bin
    poetry
    ruff
    ty
  ];
in
{
  home.packages = packages;
  programs.pyenv = {
    enable = true;
    enableFishIntegration = true;
  };
}
