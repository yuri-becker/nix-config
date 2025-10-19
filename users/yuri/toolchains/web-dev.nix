# Module for Web Application Development
{ pkgs, ... }:
let
  packages = with pkgs; [
    hoppscotch
    prettier
    superhtml
    typescript-language-server
    vscode-css-languageserver
  ];
  linuxPackages = with pkgs; if stdenv.isLinux then [ epiphany ] else [ ];
in
{
  home.packages = packages ++ linuxPackages;
  programs.helix.languages.language = [
    {
      name = "css";
      language-servers = [
        "vscode-css-language-server"
        "wakatime"
      ];
      formatter.command = "${pkgs.prettier}/bin/prettier";
      formatter.args = [
        "--parser"
        "css"
      ];
    }
    {
      name = "html";
      language-servers = [
        "superhtml"
        "wakatime"
      ];
      formatter.command = "${pkgs.prettier}/bin/prettier";
      formatter.args = [
        "--parser"
        "html"
      ];
    }
  ];
}
