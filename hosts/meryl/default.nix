{
  lib,
  specialArgs,
  pkgs,
  ...
}:
let
  hostname = "meryl";
in
{
  imports = [
    ../../mixins/docker.nix
    ../../mixins/nix-options.nix
    ./audio.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./mouse.nix
    ./pam.nix
    ./users
    specialArgs.sops-nix.nixosModules.sops
  ];

  system.stateVersion = "25.05";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-fe6e29aa-65b3-4153-b2c2-39d34734a70a".device =
      "/dev/disk/by-uuid/fe6e29aa-65b3-4153-b2c2-39d34734a70a";
  };

  networking = {
    hostName = hostname;
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

  services.udev = {
    packages = with pkgs; [
      qmk-udev-rules
      via
    ];
  };

  # Epomaker Alice 66, Keychron Q11 and Logitech Bolt thingy
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="300a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl" 
    KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", TAG+="uaccess" 
  '';

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "beeper"
      "via"
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5"
  ];

}
