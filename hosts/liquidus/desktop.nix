{ ... }:
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
  services.gnome = {
    sushi.enable = true;
    core-apps.enable = false;
    gnome-initial-setup.enable = false;
    gnome-remote-desktop.enable = false;
  };
}
