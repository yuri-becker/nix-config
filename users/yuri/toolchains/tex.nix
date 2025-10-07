# Module for TeX Documentation
{ pkgs, ... }:
{
  programs.texlive = {
    enable = true;
    packageSet = pkgs.texlive;
    extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
  };
}
