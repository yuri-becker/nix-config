{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jdt-language-server
    jdk
  ];
  programs.zed-editor = {
    extensions = [ "java" ];
    extraPackages = with pkgs; [
      jdt-language-server
      jdk
    ];
  };
}
