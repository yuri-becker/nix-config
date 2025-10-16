# Module for Web Application Development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hoppscotch
    prettier
    superhtml
    typescript-language-server
    vscode-css-languageserver
    # Webkit browser for testing
    (if stdenv.isLinux then epiphany else builtins.null)
  ];

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
