{ ... }:
{
  programs.tmux.enable = true;
  environment.etc."tmux.conf".source = ../config/tmux/tmux.conf;
}
