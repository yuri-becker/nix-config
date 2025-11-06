{
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFile = ./geary-work.secrets.yaml;
  templateFile = "geary.ini";
in
{
  home.packages = [
    pkgs.evolution
  ];
  xdg.autostart.entries = [ "${pkgs.evolution}/share/applications/org.gnome.Evolution.desktop" ];

  sops.secrets = {
    "geary/incoming/login".sopsFile = sopsFile;
    "geary/incoming/host".sopsFile = sopsFile;
    "geary/outgoing/host".sopsFile = sopsFile;
    "geary/signature".sopsFile = sopsFile;
    "geary/sender_mailboxes".sopsFile = sopsFile;
  };

  sops.templates."${templateFile}".content = lib.generators.toINI { } {
    Metadata = {
      version = 1;
      status = "enabled";
    };
    Account = {
      ordinal = 1;
      label = "";
      prefetch_days = 14;
      save_drafts = true;
      save_sent = true;
      use_signature = true;
      signature = config.sops.placeholder."geary/signature";
      sender_mailboxes = config.sops.placeholder."geary/sender_mailboxes";
      service_provider = "other";
    };
    Folders = {
      archive_folder = "Archive";
      drafts_folder = "";
      sent_folder = "";
      junk_folder = "";
      trash_folder = "";
    };
    Incoming = {
      host = config.sops.placeholder."geary/incoming/host";
      port = 993;
      login = config.sops.placeholder."geary/incoming/login";
      credentials = "custom";
      remember_password = true;
      transport_security = "transport";
    };
    Outgoing = {
      host = config.sops.placeholder."geary/outgoing/host";
      port = 465;
      credentials = "use-incoming";
      remember_password = true;
      transport_security = "transport";
    };
  };

  xdg.configFile."geary/account_01/geary.ini".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."${templateFile}".path;
}
