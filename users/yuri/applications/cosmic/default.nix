{config, lib, pkgs,...}: {
config = lib.mkIf config.localhost.cosmic.enable {
    home.packages = with pkgs; [
      phinger-cursors
      (whitesur-icon-theme.override { themeVariants = [ "purple" ]; })
    ];
    home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light";
};
}
