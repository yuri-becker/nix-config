{
  config,
  lib,
  pkgs,
  ...
}:
let
  logid-cfg =
    # See https://github.com/PixlOne/logiops/blob/main/logid.example.cfg
    builtins.toFile "logid.cfg" ''
      devices: (
      {
        name: "MX Master 3S For Business";
        smartshift: {
          on: true;
          threshold: 255;
        };
        buttons: (
          {
            cid: 0xc4;
            action: {
              type: "keypress";
              keys: ["KEY_F13"];
            };
          }
        );
      }
      );
    '';
in
{
  environment.systemPackages =
    with pkgs;
    lib.mkIf config.localhost.office.enable [
      logiops
      gutenprint
    ];

  systemd.services."logiops-daemon" = lib.mkIf config.localhost.office.enable {
    description = "Logitech Options Daemon";
    serviceConfig = {
      User = "root";
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.logiops} -v --config ${logid-cfg}";
    };
    wantedBy = [ "graphical.target" ];
  };
}
