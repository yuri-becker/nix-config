{
  appimageTools,
  fetchurl,
  lib,
  ...
}:
let

  pname = "fluxer";
  version = "0.0.8";
  src = fetchurl {
    url = "https://api.fluxer.app/dl/desktop/stable/linux/arm64/fluxer-stable-0.0.8-arm64.AppImage";
    hash = "sha256-wxLNekbw3E0YPcC27COWtp8VphKmBB9bF2dp7lnjPf8=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail Exec=AppRun Exec=$out/bin/${pname}

    install -Dm644 \
      ${appimageContents}/usr/share/icons/hicolor/256x256/apps/fluxer.png \
      $out/share/icons/hicolor/256x256/apps/fluxer.png
  '';

  meta = {
    description = "Fluxer desktop client";
    homepage = "https://fluxer.app";
    license = lib.licenses.agpl3Only;
    platforms = [ "aarch64-linux" ];
    mainProgram = "fluxer";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
