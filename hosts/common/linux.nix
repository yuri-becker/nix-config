x{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    environment.systemPackages =
      with pkgs;
      lib.optionals config.localhost.enable [ vial ]
      ++ lib.optionals config.localhost.office.enable [
        logiops
        gutenprint
      ];

    services.udev = {
      packages = with pkgs; [ qmk-udev-rules ];
      # Epomaker Alice 66 and Keychron Q11
      extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="300a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    systemd.services."logiops-daemon" =
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
      lib.mkIf config.localhost.office.enable {
        description = "Logitech Options Daemon";
        serviceConfig = {
          User = "root";
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.logiops} -v --config ${logid-cfg}";
        };
        wantedBy = [ "graphical.target" ];
      };

    virtualisation.docker = lib.mkIf config.docker.enable {
      enable = true;
      rootless.enable = true;
      rootless.setSocketVariable = true;
    };
    programs.nix-ld = lib.mkIf config.localhost.enable { enable = true; };
  };
}
