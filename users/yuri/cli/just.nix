{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = with pkgs; [ just ];
    programs.fish.shellAbbrs.j = "just";
  };
}
