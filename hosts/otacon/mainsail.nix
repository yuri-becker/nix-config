{ ... }:
{
  services.mainsail.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 ];
}
