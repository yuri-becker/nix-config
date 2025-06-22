{ config, pkgs, ... }: {
  imports = [
    ./presets/local-hosts.nix
    ./presets/darwin.nix
    ./toolchains/mobile-dev.nix
    ./toolchains/python.nix
    ./toolchains/rust.nix
    ./toolchains/web-dev.nix
  ];
  home.packages = with pkgs; [
    borgbackup
    cyberduck
    ghidra
    gimp
    iina
    moonlight-qt
    nmap
    openscad
    transmission_4-qt
    woodpecker-cli
  ];
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;
}
