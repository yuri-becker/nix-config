{ pkgs, ... }:
{
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # Locks Screen when Yubikey is unplugged
  services.udev.extraRules = ''
    ACTION=="remove",\
      ENV{ID_BUS}=="usb",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_VENDOR}=="Yubico",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
