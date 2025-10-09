{
  lib,
  appimageTools,
  fetchurl,
}:
let
  version = "11.0.2";
  pname = "moosync";
  src = fetchurl {
    url = "https://github.com/Moosync/Moosync/releases/download/Moosync-v${version}/Moosync_${version}_amd64.AppImage";
    sha256 = "LFN15X2bDDK4AhvN+F9jkzjKRxcIutOva5fla4fVqS4=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # extraInstallCommands = ''
  #   substituteInPlace $out/share/applications/${pname}.desktop \
  #     --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  # '';
  # meta = {
  #   description = "Music Player for Subsonic/Navidrome";
  #   homepage = "https://moosync.app/";
  #   downloadPage = "https://github.com/Moosync/Moosync/releases";
  #   license = lib.licenses.gpl3;
  #   sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  #   platforms = [ "x86_64-linux" ];
  # };

}
