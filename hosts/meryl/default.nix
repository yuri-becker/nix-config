{
  lib,
  specialArgs,
  pkgs,
  ...
}:
{
  imports = [
    ./audio.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./pam.nix
    ./users.nix
    specialArgs.sops-nix.nixosModules.sops
  ];
  podman.enable = true;
  localhost.enable = true;
  localhost.office.enable = true;

  system.stateVersion = "25.05";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-fe6e29aa-65b3-4153-b2c2-39d34734a70a".device =
      "/dev/disk/by-uuid/fe6e29aa-65b3-4153-b2c2-39d34734a70a";
  };

  networking = {
    hostName = "meryl";
    networkmanager.enable = true;
  };
  console.keyMap = "uk"; # Machine has a UK layout
  services.printing.drivers = with pkgs; [ gutenprint ];

  environment.systemPackages = with pkgs; [
    qemu
    quickemu
  ];
}
