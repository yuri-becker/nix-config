# home file for computers that i work on
{ config, pkgs, ... }: {
  fonts.fontconfig.enable = true;
  imports = [
    ./common.nix
    ../applications/kitty.nix
    ../applications/vesktop.nix
    ../applications/wakatime.nix
  ];
  home.packages = with pkgs; [
    age
    commitlint-rs
    erdtree
    ffmpeg-full
    meslo-lgs-nf
    yubikey-manager
  ];

  programs.ssh = {
    enable = true;
    matchBlocks."catboy-house" = {
      hostname = "46.4.241.139";
      user = "yuri";
      identityFile = "${config.home.homeDirectory}/.ssh/id_rsa"; # TODO
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
      identityFile = "~/.ssh/id_github";
    };
  };
}
