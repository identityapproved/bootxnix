# yazi: cd to the directory yazi was left in on exit.
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# fuzzy-pick a command, then man / tldr it
fman()  { local c; c=$(print -rl -- ${(k)commands} | sort -u | fzf --no-preview) && man "$c"; }
ftldr() { if (( $# )); then tldr "$@"; return; fi
          local c; c=$(print -rl -- ${(k)commands} | sort -u | fzf --no-preview) && tldr "$c"; }

# fuzzy-pick a path under $HOME and cd into its directory
fcd() { cd ~ || return; local t; t=$(fzf | sed 's:/[^/]*$::') && [[ -n "$t" ]] && cd "$t"; }

# fuzzy-pick a file and open/cat/bat it
fv()   { local f; f=$(fzf) && [[ -n "$f" ]] && vim "$f"; }
fcat() { local f; f=$(find . -type f | fzf) && [[ -n "$f" ]] && cat "$f"; }
fbat() { local f; f=$(find . -type f | fzf) && [[ -n "$f" ]] && bat "$f"; }

# scratch markdown buffer
vt() { vim "$(mktemp "${TMPDIR:-/tmp}/vt-XXXXXX.md")"; }

# fuzzy alias / git-alias browsers
falias() { alias | fzf; }
galias() { git config --get-regexp '^alias\.' | fzf; }

# process picker: view PID -> clipboard, or -k to kill
pz() {
  local sort_option="" header="Search processes" action="view"
  while (( $# )); do
    case "$1" in
      -m|--mem)  sort_option="--sort=-%mem"; header="By memory" ;;
      -k|--kill) action="kill"; header="Kill process" ;;
      -h|--help) echo "Usage: pz [-m|--mem] [-k|--kill]"; return 0 ;;
    esac
    shift
  done
  local selection pid confirm
  selection=$(ps aux $sort_option | fzf --ansi --header="$header" --height=80% \
    --preview='pid=$(echo {} | awk "{print \$2}"); ps -p $pid -o pid=,ppid=,user=,%cpu=,%mem=,etime=,cmd=') || return
  pid=$(echo "$selection" | awk '{print $2}')
  [[ -z "$pid" ]] && return 1
  if [[ "$action" == kill ]]; then
    read "confirm?Kill PID $pid? [y/N]: "
    [[ "$confirm" == [Yy] ]] && sudo kill -9 "$pid" && echo "killed $pid"
  else
    echo -n "$pid" | xclip -selection clipboard && echo "PID $pid copied"
  fi
}
