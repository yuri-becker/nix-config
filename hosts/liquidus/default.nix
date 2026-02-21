{ pkgs, specialArgs, ... }:
{
  imports = [
    ./desktop.nix
    ./hardware-configuration.nix
    ./users.nix
    specialArgs.apple-silicon.nixosModules.apple-silicon-support
    specialArgs.sops-nix.nixosModules.sops
  ];
  localhost.enable = true;
  yubikey-pam.enable = true;

  system.stateVersion = "25.05";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };

  networking = {
    hostName = "liquidus";
    networkmanager.enable = true;
  };

  hardware.asahi.enable = true;
  # hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
  #   name = "asahi";
  #   hashMode = "recursive";
  #   hash = "sha256-JVadaRQ+Oy5rGJxovNuFtUOB4Qj7Xtx9svoqiZJhth0=";
  #   message = ''
  #     nix-store --add-fixed sha256 --recursive /boot/asahi
  #   '';
  # };
  hardware.asahi.extractPeripheralFirmware = false;
  nix.settings = {
    extra-substituters = [ "https://nixos-apple-silicon.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };
}
