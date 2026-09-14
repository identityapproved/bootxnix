# History. oh-my-zsh's lib/history.zsh already set extended_history, dup
# handling, hist_verify and share_history, and floored SAVEHIST at 10000. These
# raise the size and add the four options OMZ does not set. (In lainland these
# lived in 00-omz.zsh, which NixOS's ohMyZsh replaces.)
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
