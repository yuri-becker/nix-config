{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.yubikey-pam.enable {
    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    services.pcscd.enable = true;
    security.pam.u2f.settings.cue = true;

    # Locks Screen when Yubikey is unplugged
    services.udev.extraRules = ''
      ACTION=="remove",\
        ENV{ID_BUS}=="usb",\
        ENV{ID_MODEL_ID}=="0407",\
        ENV{ID_VENDOR_ID}=="1050",\
        ENV{ID_VENDOR}=="Yubico",\
        RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';

    programs.gnupg.agent = lib.mkIf config.localhost.enable {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
