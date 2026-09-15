{ ... }:
{
  # tmux itself is installed in base.nix. We ship /etc/tmux.conf directly rather
  # than via programs.tmux.enable, which would define the same etc file and
  # conflict. tmux reads /etc/tmux.conf before any per-user config.
  environment.etc."tmux.conf".source = ../config/tmux/tmux.conf;
}
