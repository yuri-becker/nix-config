{ config, ... }:
{
  # Backup not needed since everything is stored in the database it seems
  services.homebox = {
    enable = true;
    database.createLocally = true;
    settings = {
      HBOX_WEB_PORT = "30005";
      HBOX_WEB_HOST = "127.0.0.1";
      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
    };
  };

  services.caddy.virtualHosts."inventory.home.arpa".extraConfig =
    "reverse_proxy :${config.services.homebox.settings.HBOX_WEB_PORT}";

  homer.links = [
    {
      name = "Homebox";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/homebox.png";
      url = "https://inventory.home.arpa";
    }
  ];
}
