# zsh, system-wide, shaped like lainland: a thin loader that sources
# /etc/bootxnix/zsh/rc.d/*.zsh in filename order. NixOS's programs.zsh.ohMyZsh
# stands in for lainland's 00-omz.zsh (theme "random", as in nixlabdots), so the
# rc.d modules here start at 10. No starship.
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "random";
      plugins = [ "git" "extract" "history" "sudo" ];
    };

    # oh-my-zsh.sh has already run by the time this fires, so the rc.d loop
    # only adds our own modules on top of it.
    interactiveShellInit = ''
      for _f in /etc/bootxnix/zsh/rc.d/*.zsh(N); do
        source "$_f"
      done
      unset _f
    '';
  };

  users.defaultUserShell = pkgs.zsh;

  # rc.d and the aliases file, read-only under /etc.
  environment.etc."bootxnix/zsh/rc.d".source = ../config/zsh/rc.d;
  environment.etc."bootxnix/zsh/aliases".source = ../config/zsh/aliases;
  environment.etc."bootxnix/fzf/rose-pine.fzfrc".source = ../config/fzf/rose-pine.fzfrc;
  # yazi reads $YAZI_CONFIG_HOME; ship the Rose Pine theme there (read-only).
  environment.etc."bootxnix/yazi/theme.toml".source = ../config/yazi/theme.toml;

  environment.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    PAGER = "less";
    BAT_THEME = "ansi";
    FZF_DEFAULT_OPTS_FILE = "/etc/bootxnix/fzf/rose-pine.fzfrc";
    YAZI_CONFIG_HOME = "/etc/bootxnix/yazi";
  };
}
