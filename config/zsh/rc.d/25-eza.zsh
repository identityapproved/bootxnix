# eza - listing and tree, ported from lainland with EZA_COLORS switched to the
# Rose Pine palette. Loads after 20-aliases so these win over OMZ's ls aliases.
# Without eza nothing is touched.
if command -v eza >/dev/null 2>&1; then
  # 15-colors set LS_COLORS (vivid rose-pine), which eza reads first; these
  # override the permission/size/date/type keys with Rose Pine truecolor.
  #   ur/gr/tr read=rose  uw/gw/tw write=gold  ux/gx/tx exec=love
  #   sn size number=foam sb unit=muted  da date=subtle  di dir=iris  ln=rose  ex=love
  export EZA_COLORS="\
ur=38;2;235;188;186:uw=38;2;246;193;119:ux=38;2;235;111;146:ue=38;2;235;111;146:\
gr=38;2;235;188;186:gw=38;2;246;193;119:gx=38;2;235;111;146:\
tr=38;2;235;188;186:tw=38;2;246;193;119:tx=38;2;235;111;146:\
sn=38;2;156;207;216:sb=38;2;110;106;134:da=38;2;144;140;170:\
di=38;2;196;167;231:ln=38;2;235;188;186:ex=38;2;235;111;146"

  typeset -ga _eza_flags=(--group-directories-first --icons=auto --color=auto --no-quotes)
  _eza="eza ${_eza_flags}"
  _eza_l="$_eza --long --header --smart-group --git --time-style=relative"

  # core listings
  alias ls="$_eza"
  alias l="$_eza_l --all"
  alias ll="$_eza_l"
  alias la="$_eza_l --all"
  alias lla="$_eza_l --all"
  alias lsa="$_eza_l --all"
  alias l1="$_eza --oneline"
  alias lgi="$_eza --git-ignore"
  alias ldirs="$_eza_l --only-dirs"
  alias lfiles="$_eza_l --only-files"

  # sorting
  alias lm="$_eza_l --sort=modified"
  alias lmr="$_eza_l --sort=modified --reverse"
  alias lsz="$_eza_l --sort=size --reverse"
  alias lx="$_eza_l --sort=extension"

  # detail
  alias lo="$_eza_l --octal-permissions"
  alias lb="$_eza_l --binary"
  alias lr="$_eza_l --recurse"

  # trees
  alias tree="$_eza --tree"
  alias lt="$_eza --tree --level=2"
  alias lt1="$_eza --tree --level=1"
  alias lt2="$_eza --tree --level=2"
  alias lt3="$_eza --tree --level=3"
  alias lta="$_eza --tree --level=2 --all"
  alias ltd="$_eza --tree --only-dirs"
  alias ltgi="$_eza --tree --git-ignore"

  # arbitrary depth: ltn 3 [path...]
  ltn() { local lvl=${1:-2}; shift 2>/dev/null; eza $_eza_flags --tree --level="$lvl" "$@"; }

  # list after every cd (zsh chpwd hook; add-zsh-hook refuses duplicates)
  _eza_chpwd() { eza $_eza_flags . }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _eza_chpwd

  unset _eza _eza_l
fi
