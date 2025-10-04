# Module for Python development
{ pkgs, ... }:
{
  home.packages = with pkgs.python313Packages; [
    python-lsp-server
    python-lsp-ruff
    python-lsp-black
  ];
  programs.poetry.enable = true;
  programs.ruff = {
    enable = true;
    settings = { };
  };
  programs.pyenv = {
    enable = true;
    enableFishIntegration = true;
  };
}
