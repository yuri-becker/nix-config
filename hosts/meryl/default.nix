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
  docker.enable = true;
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

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    # See https://man.archlinux.org/man/locale.5
    LC_ADDRESS = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };
  console.keyMap = "uk"; # Machine has a UK layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "beeper" ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-36.9.5" ];
}
