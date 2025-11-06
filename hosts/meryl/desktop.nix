{ pkgs, ... }:
{
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
    gnome-calendar
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

}
