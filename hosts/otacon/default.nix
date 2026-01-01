{ pkgs, specialArgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./mainsail.nix
    ./moonraker.nix
    ./klipper.nix
    specialArgs.sops-nix.nixosModules.sops
  ];

  system.stateVersion = "25.05";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "otacon";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  users.users.yuri = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWU6xP2nXWfqfsvd09JX2Mjg3yjk6hvuSa6A/1zvcK1" # liquid
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 21896 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = with pkgs; [ libcamera ];
}
