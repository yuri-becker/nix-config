{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.sane.enable = true;
  services.udev.extraRules = ''
    ATTRS{type}=="3", ATTRS{idVendor}=="04c5", ATTRS{idProduct}=="0x151f", ENV{libsane_matched}="yes"
  '';

  services.saned = {
    enable = true;
    extraConfig = ''
      localhost
      192.168.0.0/16
    '';
  };

  users.users.scanner.group = "scanner";

  systemd.services.scanbd = {
    enable = true;
    script = "${pkgs.scanbd}/bin/scanbd -c /etc/scanbd/scanbd.conf -f";
    wantedBy = [ "multi-user.target" ];
  };

  environment.etc."scanbd/scanbd.conf".source = pkgs.writeText "scanbd.conf" ''
    global {
        debug = false
        debug-level = 2
        user = scanner
        group = scanner
        scriptdir = /etc/scanbd/scripts
        pidfile = /var/run/scanbd.pid
        timeout = 500
        environment {
          device = "SCANBD_DEVICE"
          action = "SCANBD_ACTION"
        }

        multiple_actions = true
        action email {
          filter = "^email.*"
          numerical-trigger {
            from-value = 1
            to-value = 0
          }
          desc = "Scan to Paperless"
          script = "scan"
        }
      }
  '';
  environment.etc."scanbd/scripts/scan".source =
    with pkgs;
    writeScript "scan" ''
      #!${lib.getExe bash}
      export PATH=${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.img2pdf
          pkgs.ocrmypdf
          pkgs.sane-backends
          pkgs.sane-frontends
        ]
      }
      set -x
      tmpdir="$(${lib.getExe pkgs.mktemp} -d)"
      pushd "$tmpdir"

      filename="Scan $(date --iso-8601=seconds).pdf"
      scanadf -d "$SCANBD_DEVICE" --source "ADF Duplex" --mode Color --resolution 300 --page-width 210 --page-height 297
      img2pdf image-* | ocrmypdf --rotate-pages --deskew --clean-final - "$filename"

      chmod 0666 "$filename"

      cp -a "$filename" "${config.services.paperless.consumptionDir}/$filename.tmp"
      mv "${config.services.paperless.consumptionDir}/$filename.tmp" "${config.services.paperless.consumptionDir}/$filename"
      popd
      rm -r "$tmpdir"
    '';
}
