{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.threed-printing.enable {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];
  };
}
