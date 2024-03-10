{ config, pkgs, ... }:
{
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    grep = "rg";
    cla = "clear && ls -la";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    history = {
      path = "$HOME/.zsh_history";
      expireDuplicatesFirst = true;
      extended = true;
      save = 10000;
      size = 10000;
    };

    historySubstringSearch.enable = true;

    syntaxHighlighting = {
      enable = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" ];
    };

    initExtra = ''
      bindkey -v
      bindkey "^R" history-incremental-search-backward

      # Hook in direnv for dynamic Nix shell
      # https://direnv.net/
      eval "$(direnv hook zsh)"
      '';
  };
}
