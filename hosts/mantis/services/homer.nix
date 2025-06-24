{ ... }:
{
  services.homer = {
    enable = true;
    virtualHost.domain = "dash.home.arpa";
    virtualHost.caddy.enable = true;
    settings = {
      # https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md
      # https://github.com/bastienwirtz/homer/blob/main/docs/customservices.md
      title = "Shulk's Home";
      subtitle = "Yuri also goons here";
      header = false;
      footer = "";
      links = [
        {
          name = "Dashboard";
          icon = "fas fa-house-chimney";
        }
        {
          name = "Get Root Certificate";
          icon = "fas fa-certificate";
          url = "http://cert.home.arpa";
        }
      ];
      services = [
        {
          name = "Applications";
          items = [
            {
              name = "Adguard Home";
              logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/adguard-home.png";
              url = "https://dns.home.arpa";
            }
            {
              name = "Audiobookshelf";
              logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/audiobookshelf.png";
              url = "https://audiobooks.home.arpa";
            }
            {
              name = "Home Assistant";
              logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/home-assistant.png";
              url = "https://ha.home.arpa";
            }
            {
              name = "Homebox";
              logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/homebox.png";
              url = "https://inventory.home.arpa";
            }
            {
              name = "Immich";
              logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/immich.png";
              url = "https://photos.home.arpa";
            }
            {
              name = "Mainsail @ Otacon";
              logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/mainsail.png";
              url = "http://otacon.local";
            }
          ];
        }
      ];
      colors = {
        dark = {
          highlight-primary = "#cba6f7";
          highlight-secondary = "#181825";
          background = "#1e1e2e";
          card-background = "#313244";
          highlight-hover = "#313244";
          text = "#cdd6f4";
          link = "#89b4fa";
          background-image = "https://photos.home.arpa/api/assets/f6d684e5-5c28-45fd-ac50-66d8c5202e58/thumbnail?size=preview&key=KtyvqdONcMyeN2HiXh_6jHLn8eUIVOyybN0LaZyuSJ2obnz-lp29sjqmZaP_WRlSadM&c=TfcJDIKIeIeHeHdwh2l5eP%2BYpw%3D%3D";
        };
      };
    };
  };
}
