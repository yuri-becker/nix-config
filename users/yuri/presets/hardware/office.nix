{ lib, pkgs, ... }:
let
  logid-cfg =
    # See https://github.com/PixlOne/logiops/blob/main/logid.example.cfg
    builtins.toFile "logid.cfg" ''
      devices: (
        {
          name: "MX Master 3S";
          smartshift: {
            on: false;
          };
        }
      );
              
    '';
in
{
  home.packages = with pkgs; [
    logiops
    gutenprint
  ];

  systemd.user.services.logid = {
    Unit = {
      Description = "Logi Hardware Daemon";
      StartLimitIntervalSec = 0;
    };
    Install = {
      WantedBy = [ "graphical.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid -c ${logid-cfg}";
      User = "root";
    };
  };
}
