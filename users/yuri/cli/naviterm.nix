{ pkgs, naviterm, ... }:
let
  naviterm-pkgs = naviterm.packages.${pkgs.system}.default;
in
{
  home.packages = [ naviterm-pkgs ];
}
