{ specialArgs, pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./desktop.nix
    ./docker.nix
    ./hardware-configuration.nix
    ./pam.nix
    ./users
    specialArgs.sops-nix.nixosModules.sops
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

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

  # Epomaker Alice 66
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="300a", TAG+="uaccess"
  '';
}
