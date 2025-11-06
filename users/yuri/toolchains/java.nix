# Module for Python development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jdt-language-server
  ];

  programs.helix.languages = {
    language = [
      {
        name = "java";
        language-servers = [
          "jdtls"
          "wakatime"
        ];
      }
    ];
  };
}
