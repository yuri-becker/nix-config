# home file for computers that i work on
{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  imports = [
    ./common.nix
    ../cli/gitui.nix
    ../cli/just.nix
    ../cli/nix-search-tv.nix
    ../applications/feishin.nix
    ../applications/kitty.nix
    ../applications/vesktop.nix
    ../applications/wakatime.nix
  ];
  home.packages = with pkgs; [
    commitlint-rs
    erdtree
    ffmpeg-full
    meslo-lgs-nf
    yubikey-manager
  ];
  sops.age.generateKey = false;

  programs.ssh = {
    enable = true;
    matchBlocks."catboy-house" = {
      hostname = "46.4.241.139";
      user = "yuri";
      identityFile = "${config.home.homeDirectory}/.ssh/id_catboy-house"; # TODO change key
    };
    matchBlocks."*.repo.borgbase.com" = {
      hostname = "%h";
      identityFile = "${config.home.homeDirectory}/.ssh/id_borgbase";
    };
    matchBlocks."mantis" = {
      hostname = "192.168.0.11";
      user = "yuri";
      port = 20615;
      identityFile = "${config.home.homeDirectory}/.ssh/id_mantis";
    };
    matchBlocks."github.com" = {
      user = "git";
      identityFile = "${config.home.homeDirectory}/.ssh/id_github";
    };
  };
}
