{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Sean Huskey";
    userEmail = "seanhuskey@gmail.com";
  };
}
