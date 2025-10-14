# Module for Python development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    basedpyright
  ];

  programs.pyenv = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.poetry.enable = true;
  programs.uv = {
    enable = true;
    settings = { };
  };
  programs.ruff = {
    enable = true;
    settings = { };
  };

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
