{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    systemd.user.services.audio-setup =
      let
        samplerate = "192000";
        pw-metadata = "${pkgs.pipewire}/bin/pw-metadata";
        pipewire-setup = pkgs.writeShellScriptBin "pipewire-setup" ''
          # BITRATE
          ${pw-metadata} --name settings 0 clock.force-rate ${samplerate}
        '';
      in
      {
        Unit.Description = "Sets up Audio devices";
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = lib.getExe pipewire-setup;
      };
    home.packages = with pkgs; [ crosspipe ];
  };
}
