{
  config,
  lib,
  pkgs,
  ...
}:
let
  scanservjs = {
    domain = "scan.home.arpa";
    port = 30004;
    config = pkgs.writeText "config.local.js" ''
      const options = { paths: ['/usr/lib/scanservjs'] };
      const Process = require(require.resolve('./server/classes/process', options));
      const dayjs = require(require.resolve('dayjs', options));

      module.exports = {
        afterConfig(config) {
          config.ocrLanguage = 'eng ger';
          const myPipelines = [ ];
          // config.pipelines.push(myPipelines[0]);
        },

        afterDevices(devices) {
          const device = devices.filter(d => d.id.startsWith('fujitsu'))[0];
          if (device) {
            device.name = "Fujitsu Document Scanner";
            device.features['--mode'].default = 'Color';
            device.features['--resolution'].default = 300;
          }
        },

        async afterScan(fileInfo) { },
        actions: [ ]
      };
    '';
  };
in
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

  virtualisation.oci-containers.containers.scanservjs = {
    image = "sbs20/scanservjs:latest";
    autoStart = true;
    ports = [ "127.0.0.1:${toString scanservjs.port}:8080" ];
    privileged = true;
    volumes = [
      "/var/run/dbus:/var/run/dbus"
      "${scanservjs.config}:/etc/scanservjs/config.local.js"
    ];
  };
  services.caddy.virtualHosts."${scanservjs.domain}".extraConfig =
    "reverse_proxy :${toString scanservjs.port}";

  homer.links = [
    {
      name = "Document Scanner";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/png/ksuite-docs.png";
      url = "https://${scanservjs.domain}";
    }
  ];

  systemd.services.scanbd = {
    enable = false;
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
      img2pdf image-* | ocrmypdf --rotate-pages --deskew - "$filename"

      chmod 0666 "$filename"

      cp -a "$filename" "${config.services.paperless.consumptionDir}/$filename.tmp"
      mv "${config.services.paperless.consumptionDir}/$filename.tmp" "${config.services.paperless.consumptionDir}/$filename"
      popd
      rm -r "$tmpdir"
    '';
}
