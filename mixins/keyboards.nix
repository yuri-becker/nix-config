{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vial ];
  services.udev = {
    packages = with pkgs; [ qmk-udev-rules ];
    # Epomaker Alice 66 and Keychron Q11
    extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="300a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';

  };
}
