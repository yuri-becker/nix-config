{ config, ... }:
let
  upstreamServers = {
    quad9 = {
      tls = "tls://dns.quad9.net";
      v4.primary = "9.9.9.9";
      v4.secondary = "149.112.112.112";
      v6.primary = "2620:fe::fe";
      v6.secondary = "2620:fe::9";
    };
    cloudflare = {
      v4.primary = "1.1.1.1";
      v4.secondary = "1.0.0.1";
      v6.primary = "2606:4700:4700::1111";
      v6.secondary = "2606:4700:4700::1001";
    };
  };
  bootstrap = with upstreamServers; [
    quad9.v6.primary
    quad9.v4.primary
    cloudflare.v6.primary
    cloudflare.v4.primary
    quad9.v6.secondary
    quad9.v4.secondary
    cloudflare.v6.secondary
    cloudflare.v4.secondary
  ];
  upstream = with upstreamServers; [ quad9.tls ] ++ bootstrap;
in
{
  services.adguardhome = {
    enable = true;
    port = 30001;
    mutableSettings = false;
    settings.users = [
      {
        name = "yuri";
        password = "$2y$10$QjqU2Jpfuk6ie.UG4tKer.V37t6n7B/urRIaCL15W860r7zSpzo7W";
      }
    ];
    settings.dns.bind_hosts = [
      "192.168.0.11"
      "127.0.0.1"
    ];
    settings.dns.upstream_dns = upstream;
    settings.dns.bootstrap_dns = bootstrap;
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
    settings.filtering = {
      blocked_services.ids = [ "tiktok" ];
      rewrites = [
        {
          enabled = true;
          domain = "*.home.arpa";
          answer = "192.168.0.11";
        }
      ];
    };
  };
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.caddy.virtualHosts."dns.home.arpa".extraConfig =
    "reverse_proxy :${toString config.services.adguardhome.port}";
  homer.links = [
    {
      name = "Adguard Home";
      logo = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/adguard-home.png";
      url = "https://dns.home.arpa";
    }
  ];
}
