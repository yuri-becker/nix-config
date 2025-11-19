# Module for Web Application Development
{ pkgs, ... }:
{
  home.packages = with pkgs; [ bruno ] ++ lib.optionals stdenv.isLinux [ epiphany ];
}
