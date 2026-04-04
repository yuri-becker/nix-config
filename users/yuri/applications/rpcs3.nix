{
  config,
  lib,
  pkgs,
  ...
}:
let
  usbdev = {
    Path = "";
    Serial = "";
    VID = "";
    PID = "";
  };
in
{
  config = lib.mkIf config.localhost.gaming.enable {
    home.packages = [ pkgs.rpcs3 ];
    xdg.configFile."rpcs3/vfs.yml".text = lib.generators.toYAML { } {
      "$(EmulatorDir)" = "/home/yuri/Nextcloud/Savegames/RPCS3/";
      "/dev_hdd0/" = "$(EmulatorDir)dev_hdd0/";
      "/dev_hdd1/" = "$(EmulatorDir)dev_hdd1/";
      "/dev_flash/" = "$(EmulatorDir)dev_flash/";
      "/dev_flash2/" = "$(EmulatorDir)dev_flash2/";
      "/dev_flash3/" = "$(EmulatorDir)dev_flash3/";
      "/dev_bdvd/" = "$(EmulatorDir)dev_bdvd/";
      "/games/" = "/home/yuri/Games/ROMs/PS3/";
      "/app_home/" = "";
      "/dev_usb***/" = {
        "/dev_usb000" = {
          inherit (usbdev) Serial VID PID;
          Path = "$(EmulatorDir)dev_usb000/";
        };
      }
      // lib.genAttrs [
        "/dev_usb001"
        "/dev_usb002"
        "/dev_usb003"
        "/dev_usb004"
        "/dev_usb005"
        "/dev_usb006"
        "/dev_usb007"
      ] (_: usbdev);
    };
  };
}
