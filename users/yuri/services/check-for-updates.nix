{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    systemd.user.services.check-for-updates =
      let
        notifier = "${lib.getExe pkgs.libnotify} --icon software-update-available --app-name 'Available Updates'";
        script = pkgs.writeShellScriptBin "check-for-updates" ''
          tempdir=$(mktemp -d)
          cp -r "${specialArgs.self}/." "$tempdir/"
          chmod -R u+wx "$tempdir"
          cd "$tempdir"
          just update
          just rebuild build
          output=$(nix store diff-closures /run/current-system ./result | awk '/[0-9] →|→ [0-9]/ && !/nixos/')
          cd ~
          rm -rf "$tempdir"
          echo "Output: $output"
          if [[ -n "$output" ]]; then
            ${notifier} "$output"
          fi
        '';
      in
      {
        Unit.Description = "Checks for Updates";
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = lib.getExe script;
        Service.Type = "simple";
      };

    systemd.user.timers.check-for-updates = {
      Unit.Description = "Checks for updates daily";
      Timer.OnCalendar = "daily";
      Timer.Unit = "check-for-updates.service";
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
