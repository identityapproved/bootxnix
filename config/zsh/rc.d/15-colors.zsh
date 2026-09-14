# LS_COLORS from vivid's rose-pine theme, so coreutils ls and every eza alias
# in 25-eza share one palette. Guarded on the binary; without vivid, colours
# fall back to the terminal default.
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate rose-pine 2>/dev/null)"
fi
