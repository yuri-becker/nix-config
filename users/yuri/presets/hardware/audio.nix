{ lib, pkgs, ... }:
let
  pipewire-setup =
    with pkgs;
    let
      pw-link = "${pkgs.pipewire}/bin/pw-link";
      pw-metadata = "${pkgs.pipewire}/bin/pw-metadata";
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      virtual-speaker = "Virtual-Speaker";
      virtual-mic = "Virtual-Microphone";
      k5 = "alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K5_Pro-00.iec958-stereo";
      btr5 = "alsa_output.usb-FiiO_FiiO_BTR5-00.analog-stereo";
      sc-420 = "alsa_input.usb-USB_MICROPHONE_USB_MICROPHONE_20190809-00.analog-stereo";
      trashy-thinkpad-mic = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source";
    in
    writeShellScriptBin "pipewire-setup" ''
      # Bitrate
      ${pw-metadata} --name settings 0 clock.force-rate 384000

      # Create virtual devices
      if [[ ''$(pw-link -i | grep '${virtual-speaker}' | wc --lines) -eq 0 ]]; then
        ${pactl} load-module module-null-sink sink_name=${virtual-speaker} sink_properties=device.description=${virtual-speaker}
      fi
      if [[ ''$(pw-link -i | grep '${virtual-mic}' | wc --lines) -eq 0 ]]; then
        ${pactl} load-module module-remap-source source_name=${virtual-mic}
      fi

      # Output: Fiio K5
      ${pw-link} ${virtual-speaker}:monitor_FL ${k5}:playback_FL
      ${pw-link} ${virtual-speaker}:monitor_FR ${k5}:playback_FR
      # Output: Fiio BTR5
      ${pw-link} ${virtual-speaker}:monitor_FL ${btr5}:playback_FL
      ${pw-link} ${virtual-speaker}:monitor_FR ${btr5}:playback_FR

      # Input: SC 420
      ${pw-link} ${sc-420}:capture_FL input.${virtual-mic}:input_FL
      ${pw-link} ${sc-420}:capture_FR input.${virtual-mic}:input_FR
      # Input: Thinkpad Microphone
      ${pw-link} ${trashy-thinkpad-mic}:capture_FL input.${virtual-mic}:input_FL
      ${pw-link} ${trashy-thinkpad-mic}:capture_FR input.${virtual-mic}:input_FR
    '';
in
{
  systemd.user.services.bitrate = {
    Unit.Description = "Sets up Audio devices";
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = lib.getExe pipewire-setup;
  };
  home.packages = with pkgs; [ helvum ];
}
