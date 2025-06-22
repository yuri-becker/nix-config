{ ... }: {
  system.primaryUser = "yuri";
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0;
    tilesize = 64;
    magnification = false;
    mineffect = "scale";
  };
  system.defaults.finder = {
    AppleShowAllFiles = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };
}
