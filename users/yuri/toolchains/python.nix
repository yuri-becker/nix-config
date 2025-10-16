# Module for Python development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    basedpyright
    ruff
  ];

  programs.helix.languages = {
    language-server.basedpyright.config.basedpyright.analysis = {
      # See https://github.com/microsoft/pyright/blob/main/docs/configuration.md
      typeCheckingMode = "strict";
      diagnosticSeverityOverrides = {
        reportUnusedCallResult = "none";
      };
    };
    language = [
      {
        name = "python";
        formatter.command = "${pkgs.ruff}/bin/ruff";
        formatter.args = [
          "format"
          "--silent"
          "-"
        ];
        language-servers = [
          "basedpyright"
          "ruff"
          "wakatime"
        ];
      }
    ];
  };
}
