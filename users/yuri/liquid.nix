{ pkgs, ... }:
{
  imports = [
    ./presets/common.nix
    ./presets/locality/local-hosts.nix
    ./presets/os/darwin.nix
    ./presets/usecase/personal.nix
  ];
  home.packages = with pkgs; [
    borgbackup
    ghidra
    iina
    moonlight-qt
    nmap
    openscad
    transmission_4-qt
    whisky
    woodpecker-cli
  ];
  programs.home-manager.enable = true;
  programs.yt-dlp.enable = true;
}
