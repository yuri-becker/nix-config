{ specialArgs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./users
    specialArgs.sops-nix.nixosModules.sops
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-fe6e29aa-65b3-4153-b2c2-39d34734a70a".device =
    "/dev/disk/by-uuid/fe6e29aa-65b3-4153-b2c2-39d34734a70a";

  networking.hostName = "meryl";
  networking.networkmanager.enable = true;

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

  services.xserver.enable = true; # @Future Me: This enables Wayland as well
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };
  environment.gnome.excludePackages = with pkgs; [
    decibels
    geary
    gnome-console
    gnome-contacts
    gnome-clocks
    gnome-music
    gnome-logs
    gnome-text-editor
    gnome-system-monitor
    loupe
    totem
    yelp
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.printing.enable = true;
  services.pcscd.enable = true;
}
