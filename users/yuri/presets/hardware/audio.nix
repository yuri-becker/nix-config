{ ... }:
{
  systemd.user.services.bitrate = {
    Unit.Description = "Set Bitrate in Pipewire";
    Install.WantedBy = [ "graphical.target" ];
    Service.ExecStart = ''/run/current-system/sw/bin/pw-metadata --name settings 0 clock.force-rate 384000'';
  };
}
