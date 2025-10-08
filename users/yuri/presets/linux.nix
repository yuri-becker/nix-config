# Config file for linux systems
{ config, ...}: {
    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
}
