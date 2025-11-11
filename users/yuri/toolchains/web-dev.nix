# Module for Web Application Development
{ lib, pkgs, ... }:
let
  packages = with pkgs; [
    bruno
    prettier
    superhtml
    typescript-language-server
    vscode-css-languageserver
  ];
  linuxPackages = with pkgs; if stdenv.isLinux then [ epiphany ] else [ ];
  angular = {
    queries = "helix/runtime/queries/angular/";
    indents = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/refs/heads/main/runtime/queries/angular/indents.scm";
      sha256 = "1z6g85rs0xwkn5h0946kqghxashr1fsrv25b2rzamsvffwc6a2kh";
    };
    highlights = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/refs/heads/main/runtime/queries/angular/highlights.scm";
      sha256 = "00qccasm1j8if0vpzqgpfp7bxz7566dq3lyh1k0pjanhbkmvl5qs";
    };
    locals = builtins.fetchurl {
      url = "https://github.com/nvim-treesitter/nvim-treesitter/blob/main/runtime/queries/angular/locals.scm";
      sha256 = "0gg5wxw1czlaxs99hdskzqvhsdx3gj2fs3bq9izkqlmmp60hn00c";
    };
  };
in
{
  home.packages = packages ++ linuxPackages;

  programs.helix.languages = {
    language-server.angular = {
      command = "${pkgs.angular-language-server}/bin/ngserver";
      args = [
        "--stdio"
        "--tsProbeLocations"
        "${pkgs.typescript}/lib/node_modules/typescript/lib"
        "--ngProbeLocations"
        "${pkgs.angular-language-server}/lib/bin"
      ];
      file-types = [
        "ts"
        "typescript"
        "html"
      ];
    };
    grammar = [
      {
        name = "angular";
        source.git = "https://github.com/dlvandenberg/tree-sitter-angular";
        source.rev = "15590fdaf2edbd33e5883b22c844eef545320fc5";
      }
    ];
    language = [
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
      {
        name = "angular";
        scope = "source.angular";
        injection-regex = "html";
        roots = [ "angular.json" ];
        file-types = [ "html" ];
        language-servers = [
          "angular"
          "wakatime"
        ];
        grammar = "angular";
        auto-format = true;
        indent.tab-width = 2;
        indent.unit = "  ";
        formatter.command = "${pkgs.prettier}/bin/prettier";
        formatter.args = [
          "--parser"
          "angular"
        ];
      }
    ];
  };
  xdg.configFile."${angular.queries}highlights.scm".source = angular.highlights;
  xdg.configFile."${angular.queries}indents.scm".source = angular.indents;
  xdg.configFile."${angular.queries}locals.scm".source = angular.locals;
}
