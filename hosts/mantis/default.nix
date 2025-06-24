{ specialArgs, pkgs, ... }:
{
  deployment = {
    targetHost = "mantis";
    tags = [ "lan" ];
  };

  imports = [
    ./hardware-configuration.nix
    ./services
    ./users
    specialArgs.sops-nix.nixosModules.sops
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mantis";
  networking.interfaces.enp60s0.wakeOnLan.enable = true;

  system.stateVersion = "25.05";

  services.openssh = {
    enable = true;
    ports = [ 20615 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    usbutils
  ];
  sops.gnupg.sshKeyPaths = [ ];
}
