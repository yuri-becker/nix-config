{ pkgs, ... }: {
  programs.bat.enable = true;
  programs.fish.functions.cat =
    "${pkgs.bat}/bin/bat --plain --pager never $argv";

}
