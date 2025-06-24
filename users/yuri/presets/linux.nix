# Config file for linux systems
{ config, ...}: {
    sops.age.keyFile = "${config.home.homeDirecotry}/.config/sops/age/keys.txt";
}