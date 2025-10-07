# Module for Python development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    basedpyright
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

  programs.helix.languages = {
    language-server.basedpyright.config.python = {
      # See https://github.com/microsoft/pyright/blob/main/docs/configuration.md
      typeCheckingMode = "strict";
      reportPropertyTypeMismatch = "error";
      reportMissingTypeStubs = "warning";
      reportImportCycles = "warning";
      reportUnusedImport = "warning";
      reportUnusedClass = "warning";
      reportUnusedFunction = "warning";
      reportUnusedVariable = "warning";
      reportDuplicateImport = "warning";
      reportPrivateUsage = "warning";
      reportDeprecated = "warning";
      reportConstantRedefinition = "warning";
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
