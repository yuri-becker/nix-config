{ config, ... }:
let
  sopsFile = ./adguard.secrets.yaml;
in
{
  sops.secrets."adguard/passwords/yuri".sopsFile = sopsFile;
  services.adguardhome = {
    enable = true;
    port = 30001;
    mutableSettings = false;
    settings.users = [
      {
        name = "yuri";
        password = config.sops.placeholder."adguard/passwords/yuri"; # TODO, doesnt work like this
      }
    ];
    settings.dns.bind_hosts = [
      "192.168.0.11"
      "127.0.0.1"
    ];
    settings.dns.upstream_dns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
    ];
    settings.dns.bootstrap_dns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
    ];
    settings.statistics.interval = "8760h";
    settings.filters = [
      {
        enabled = true;
        ID = "adguard_dns";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        name = "AdGuard DNS filter";
      }
      {
        enabled = true;
        ID = "ublock_badware";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
        name = "uBlock₀ filters – Badware risks";
      }
    ];
    settings.filtering.blocked_services.ids = [ "tiktok" ];
    settings.filtering.rewrites = [
      {
        domain = "*.home.arpa";
        answer = "192.168.0.11";
      }
    ];
  };
  services.caddy.virtualHosts."dns.home.arpa".extraConfig =
    "reverse_proxy :${toString config.services.adguardhome.port}";
  networking.firewall.allowedUDPPorts = [ 53 ];
}
