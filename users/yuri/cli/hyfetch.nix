{ ... }: {
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "pansexual";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align.mode = "vertical";
      backend = "fastfetch";
    };
  };
}
