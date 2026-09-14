# zoxide - highest-numbered module so it initializes last (it appends to
# chpwd_functions and warns if something later reassigns the array). Guarded on
# the binary; without it, cd is the shell builtin.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi
