{ config, ... }:
let
  toIntString = num: toString (builtins.floor num);
  nunito.regular = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/vernnobile/NunitoFont/refs/heads/master/version-2.0/Nunito-Regular.ttf";
    sha256 = "sha256:00v7ap52xg25zggx33kixkj23id9gmg9rpg0p81v7fanj7im96cp";
  };
  nunito.semibold = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/vernnobile/NunitoFont/refs/heads/master/version-2.0/Nunito-SemiBold.ttf";
    sha256 = "sha256:0h86ig312fm0sdh3ph3dk64xsxpgafqbjbg78mjvcnbwhnx2s048";
  };
  labelSizes.globals = {
    pixelsPerCm = 38;
    margin = 0.3 * labelSizes.globals.pixelsPerCm;
    padding = 0.5 * labelSizes.globals.pixelsPerCm;
  };
  labelSizes.herma8638 = with labelSizes.globals; {
    HBOX_LABEL_MAKER_WIDTH = toIntString (7.0 * pixelsPerCm);
    HBOX_LABEL_MAKER_HEIGHT = toIntString (3.6 * pixelsPerCm);
    HBOX_LABEL_MAKER_MARGIN = toIntString margin;
    HBOX_LABEL_MAKER_PADDING = toIntString padding;
    HBOX_LABEL_MAKER_FONT_SIZE = toIntString 20;
  };
in
{
  # Backup not needed since everything is stored in the database it seems
  services.homebox = {
    enable = true;
    database.createLocally = true;
    settings = {
      HBOX_WEB_PORT = "30005";
      HBOX_WEB_HOST = "127.0.0.1";
      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
      HBOX_STORAGE_CONN_STRING = "file:///var/lib/homebox?no_tmp_dir=true";
      HBOX_STORAGE_PREFIX_PATH = "";
      HBOX_LABEL_MAKER_DYNAMIC_LENGTH = "false";
      HBOX_LABEL_MAKER_REGULAR_FONT_PATH = toString nunito.regular;
      HBOX_LABEL_MAKER_BOLD_FONT_PATH = toString nunito.semibold;
    }
    // labelSizes.herma8638;
  };

  services.caddy.virtualHosts."inventory.home.arpa".extraConfig =
    "reverse_proxy :${config.services.homebox.settings.HBOX_WEB_PORT}";
  backup-dirs = [ config.services.homebox.settings.HOME ];

  homer.links = [
    {
      name = "Homebox";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/homebox.png";
      url = "https://inventory.home.arpa";
    }
  ];

}
