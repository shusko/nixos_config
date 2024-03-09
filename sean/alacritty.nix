{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        background = "#272E33";
        foreground = "#d3c6aa";
        normal = {
          black = "#475258";
          blue = "#7fbbb3";
          cyan = "#83c092";
          green = "#a7c080";
          magenta = "#d699b6";
          red = "#e67e80";
          white = "#d3c6aa";
          yellow = "#dbbc7f";
        };
      };
      cursor = {
        blink_interval = 750;
        blink_timeout = 5;
        unfocused_hollow = false;
        style = {
          blinking = "On";
          shape = "Beam";
        };
      };
      mouse = {
        hide_when_typing = true;
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      window = {
        decorations = "Full";
        dynamic_padding = true;
        dynamic_title = true;
        opacity = 1;
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        size = 10;
      };
    };
  };
}
