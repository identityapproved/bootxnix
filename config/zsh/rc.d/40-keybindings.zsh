# fzf key-bindings: CTRL-R history, CTRL-T files, CTRL-G cd.
# Deferred via zvm_after_init because zsh-vi-mode rebuilds the viins keymap on
# the first prompt and would clobber fzf's insert-mode CTRL-R.
#
# ALT-C is remapped to CTRL-G here: under dwm the mod key is Alt, so Alt+c is
# grabbed by the window manager and never reaches the shell. The completion
# trigger stays fzf's default (**<TAB>).
_bootxnix_fzf_bindings() {
  local kb=/etc/profiles/per-user/${USER}/share/fzf/key-bindings.zsh
  [[ -r $kb ]] || kb=/run/current-system/sw/share/fzf/key-bindings.zsh
  [[ -r $kb ]] && source "$kb"
  # rebind cd widget off ALT-C onto CTRL-G
  if (( $+widgets[fzf-cd-widget] )); then
    bindkey '^G' fzf-cd-widget
  fi
}
if typeset -f zvm_after_init >/dev/null 2>&1 || [[ -n ${ZVM_VERSION:-} ]]; then
  zvm_after_init_commands+=('_bootxnix_fzf_bindings')
else
  _bootxnix_fzf_bindings
fi

export FZF_DEFAULT_OPTS='--reverse --info=inline'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :100 {}'"
export FZF_CTRL_G_OPTS="--preview 'ls -1 {}'"

# Cursor shape per vi mode: beam in insert, block in command. zsh-vi-mode's own
# is left on here (no tmux DCS wrapping needed inside st), so this only sets the
# FZF alt-c note above; keeping the block minimal.
