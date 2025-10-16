{ ... }:
{
  systemd.user.services.bitrate = {
    Unit.Description = "Set Bitrate in Pipewire";
    Install.WantedBy = [ "multi-user.target" ];
    Service.ExecStart = ''pw-metadata --name settings 0 clock.force-rate 384000'';
  };
}
