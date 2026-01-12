{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.gnome.enable {
    systemd.user.services.notification-sounds =
      let
        script = pkgs.writeShellApplication {
          name = "notification-sound";
          runtimeInputs = with pkgs; [ libcanberra-gtk3 ];
          # From https://askubuntu.com/questions/1534681/notifications-are-silent-in-ubuntu-24-04-1-lts
          text = ''
            last_time=0
            dbus-monitor "interface='org.freedesktop.Notifications'" |
            while read -r line; do
                if echo "$line" | grep -q 'member=Notify'; then
                    current_time=$(date +%s%3N)
                    if (( current_time - last_time >= 5000 )); then
                        last_time=$current_time
                        ${lib.getExe pkgs.libcanberra-gtk3} -i message-new-instant
                    fi
                fi
            done
          '';
        };
      in
      {
        Unit.Description = "Plays sound on Notification";
        Unit.Requires = "gnome-session.target";
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = lib.getExe script;
        Service.Environment = [
          "DISPLAY=:0"
          "XDG_RUNTIME_DIR=/run/user/%U"
        ];
      };
  };
}
