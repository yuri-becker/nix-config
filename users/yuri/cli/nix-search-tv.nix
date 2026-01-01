{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    programs.fish = {
      functions.nix-search =
        let
          nstv = lib.getExe pkgs.nix-search-tv;
          fzf = lib.getExe pkgs.fzf;
        in
        "${nstv} print | ${fzf} --preview '${nstv} preview {}' --scheme history";
      shellAbbrs.ns = "nix-search";
    };
  };
}
