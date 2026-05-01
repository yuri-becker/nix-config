{ lib, pkgs, ... }:
let
  mkFontOption =
    { }:
    with lib;
    {
      name = mkOption { type = lib.types.str; };
      package = mkPackageOption pkgs "font package" { };
    };
in
{
  options = with lib; {
    localhost.enable = mkEnableOption "that this host is meant to be locally interacted with";
    localhost.personal.enable = mkEnableOption "toolchain for personal workloads";
    localhost.work.enable = mkEnableOption "toolchain for wage-labour-related workloads";
    localhost.gnome.enable = mkEnableOption "gnome configuration";
    localhost.gaming.enable = mkEnableOption "games!!";
    localhost.threed-printing.enable = mkEnableOption "toolchain for 3D-printing";
    localhost.font = {
      system = mkFontOption { };
      mono = mkFontOption { };
    };
    localhost.kitty.enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
}
