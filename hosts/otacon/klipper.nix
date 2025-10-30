{ config, lib, ... }:
let
  sdpath = "${config.services.moonraker.stateDir}/gcodes";
  user = "klipper";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    name = user;
    group = user;
    extraGroups = [ "dialout" ];
    isSystemUser = true;
  };
  systemd.tmpfiles.rules = [
    "d ${sdpath} 0770 ${config.services.klipper.user} ${config.services.klipper.group} - -"
  ];
  services.klipper = {
    enable = true;
    mutableConfig = true;
    user = user;
    group = user;
    settings = {
      virtual_sdcard.path = sdpath;
    };
    extraSettings = lib.concatStringsSep "\n" (
      with builtins;
      [
        (readFile ./klipper/misc-macros.cfg)
        (readFile ./klipper/PARKING.cfg)
        (readFile ./klipper/CALIBRATION.cfg)
        (readFile ./klipper/Adaptive_Meshing.cfg)
        (readFile ./klipper/Line_Purge.cfg)
        (readFile ./klipper/KAMP_Settings.cfg)
        (readFile ./klipper/TEST_SPEED.cfg)
        (readFile ./klipper/printer.cfg)
      ]
    );
  };
  systemd.services.klipper.restartTriggers = [
    # TODO: Probably contribute that to nixpkgs?
    # (builtins.hashFile "sha256" "./printer.cfg")
  ];
}
