{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    allowFrom = [ "all" ];
    listenAddresses = [ "*:631" ];
    webInterface = false;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
    publish.userServices = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Fucker";
        location = "Bedroom";
        description = "Grayscale Laser (Brother HL 1110)";
        deviceUri = "usb://Brother/HL-1110%20series?serial=G0N692557";
        model = "drv:///brlaser.drv/br1110.ppd";
        ppdOptions.PageSize = "A4";
      }
    ];
    ensureDefaultPrinter = "Fucker";
  };
}
