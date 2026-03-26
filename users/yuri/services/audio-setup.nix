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
        pw-link = "${pkgs.pipewire}/bin/pw-link";
        pw-metadata = "${pkgs.pipewire}/bin/pw-metadata";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        virtual-speaker = "Virtual-Speaker";
        virtual-mic = "Virtual-Microphone";
        k5 = "alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K5_Pro-00.iec958-stereo";
        scarlett.sink = "alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.Direct__Direct__sink";
        scarlett.source = "alsa_input.usb-Focusrite_Scarlett_Solo_USB-00.Direct__Direct__source";
        sc-420 = "alsa_input.usb-USB_MICROPHONE_USB_MICROPHONE_20190809-00.analog-stereo";
        pipewire-setup = pkgs.writeShellScriptBin "pipewire-setup" ''
          # BITRATE
          ${pw-metadata} --name settings 0 clock.force-rate ${samplerate}

          # OUTPUTS
          if [[ $(pw-link --output | grep '${virtual-speaker}' | wc --lines) -eq 0 ]]; then
            # Create Virtual Speaker
            ${pactl} load-module module-null-sink sink_name=${virtual-speaker} sink_properties=device.description=${virtual-speaker}
          fi

          if [[ $(pw-link --input | grep '${scarlett.sink}' | wc --lines) -gt 0 ]]; then
            # Scarlett Solo
            ${pw-link} ${virtual-speaker}:monitor_FL ${scarlett.sink}:playback_FL
            ${pw-link} ${virtual-speaker}:monitor_FR ${scarlett.sink}:playback_FR
          else
            # Fiio K5
            ${pw-link} ${virtual-speaker}:monitor_FL '${k5}:playback_FL'
            ${pw-link} ${virtual-speaker}:monitor_FR '${k5}:playback_FR'
          fi

          # INPUTS
          if [[ $(pw-link --input | grep '${virtual-mic}' | wc --lines) -eq 0 ]]; then
            # Create Virtual Microphone
            ${pactl} load-module module-remap-source source_name=${virtual-mic}
          fi

          if [[ $(pw-link --output | grep '${scarlett.source}' | wc --lines) -gt 0 ]]; then
            # Scarlett Solo
            ${pw-link} ${scarlett.source}:capture_FL input.${virtual-mic}:input_FL
            ${pw-link} ${scarlett.source}:capture_FL input.${virtual-mic}:input_FR # Only outputs on left
          else
            # SC 420
            ${pw-link} ${sc-420}:capture_FL input.${virtual-mic}:input_FL
            ${pw-link} ${sc-420}:capture_FR input.${virtual-mic}:input_FR
          fi
        '';
      in
      {
        Unit.Description = "Sets up Audio devices";
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = lib.getExe pipewire-setup;
      };
    home.packages = with pkgs; [ helvum ];
  };
}
