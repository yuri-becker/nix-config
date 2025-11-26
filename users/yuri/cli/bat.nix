{ lib, pkgs, ... }:
{
  programs.bat.enable = true;
  programs.fish.functions.cat = "${lib.getExe pkgs.bat} --plain --pager never $argv";
}
