{ config, pkgs, ... }:
{
  home.file.".config/awesome" = {
    source = ./awesome_wm;
    recursive = true;
  };
}
