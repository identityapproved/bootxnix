" Rose Pine (main) for vim, hand-written from lib/rose-pine.nix.
" Truecolor only (the vimrc sets termguicolors).

hi clear
if exists("syntax_on") | syntax reset | endif
set background=dark
let g:colors_name = "rose-pine"

" palette
let s:base    = "#191724"
let s:surface = "#1f1d2e"
let s:overlay = "#26233a"
let s:muted   = "#6e6a86"
let s:subtle  = "#908caa"
let s:text    = "#e0def4"
let s:love    = "#eb6f92"
let s:gold    = "#f6c177"
let s:rose    = "#ebbcba"
let s:pine    = "#31748f"
let s:foam    = "#9ccfd8"
let s:iris    = "#c4a7e7"
let s:hlow    = "#21202e"
let s:hmed    = "#403d52"
let s:hhigh   = "#524f67"

function! s:hi(group, fg, bg, attr)
  let l:cmd = "hi " . a:group
  if a:fg != "" | let l:cmd .= " guifg=" . a:fg | endif
  if a:bg != "" | let l:cmd .= " guibg=" . a:bg | endif
  if a:attr != "" | let l:cmd .= " gui=" . a:attr . " cterm=" . a:attr | endif
  execute l:cmd
endfunction

" editor
call s:hi("Normal",       s:text,   s:base,    "")
call s:hi("NormalFloat",  s:text,   s:surface, "")
call s:hi("CursorLine",   "",       s:hlow,    "")
call s:hi("CursorLineNr", s:gold,   s:hlow,    "bold")
call s:hi("LineNr",       s:muted,  "",        "")
call s:hi("SignColumn",   "",       s:base,    "")
call s:hi("ColorColumn",  "",       s:overlay, "")
call s:hi("VertSplit",    s:overlay, s:base,   "")
call s:hi("Visual",       "",       s:hmed,    "")
call s:hi("Search",       s:base,   s:gold,    "")
call s:hi("IncSearch",    s:base,   s:rose,    "")
call s:hi("MatchParen",   s:love,   s:hmed,    "bold")
call s:hi("Pmenu",        s:subtle, s:overlay, "")
call s:hi("PmenuSel",     s:text,   s:hmed,    "bold")
call s:hi("Folded",       s:muted,  s:surface, "")
call s:hi("NonText",      s:hmed,   "",        "")
call s:hi("Whitespace",   s:hmed,   "",        "")
call s:hi("Directory",    s:foam,   "",        "")
call s:hi("Title",        s:iris,   "",        "bold")
call s:hi("ErrorMsg",     s:love,   "",        "")
call s:hi("WarningMsg",   s:gold,   "",        "")

" statusline (native, palette-coloured)
call s:hi("StatusLine",   s:text,   s:overlay, "")
call s:hi("StatusLineNC", s:muted,  s:surface, "")
call s:hi("TabLine",      s:subtle, s:surface, "")
call s:hi("TabLineSel",   s:base,   s:iris,    "bold")
call s:hi("TabLineFill",  s:muted,  s:base,    "")
call s:hi("WildMenu",     s:base,   s:iris,    "")

" syntax
call s:hi("Comment",      s:muted,  "",        "italic")
call s:hi("Constant",     s:gold,   "",        "")
call s:hi("String",       s:gold,   "",        "")
call s:hi("Character",    s:gold,   "",        "")
call s:hi("Number",       s:gold,   "",        "")
call s:hi("Boolean",      s:rose,   "",        "")
call s:hi("Identifier",   s:foam,   "",        "")
call s:hi("Function",     s:rose,   "",        "")
call s:hi("Statement",    s:pine,   "",        "")
call s:hi("Conditional",  s:pine,   "",        "")
call s:hi("Keyword",      s:pine,   "",        "")
call s:hi("Operator",     s:subtle, "",        "")
call s:hi("PreProc",      s:iris,   "",        "")
call s:hi("Include",      s:iris,   "",        "")
call s:hi("Type",         s:foam,   "",        "")
call s:hi("Special",      s:rose,   "",        "")
call s:hi("Todo",         s:base,   s:gold,    "bold")

" diff / git signs
call s:hi("DiffAdd",      s:foam,   s:base,    "")
call s:hi("DiffChange",   s:gold,   s:base,    "")
call s:hi("DiffDelete",   s:love,   s:base,    "")
call s:hi("DiffText",     s:iris,   s:base,    "bold")
call s:hi("GitGutterAdd",          s:foam, "", "")
call s:hi("GitGutterChange",       s:gold, "", "")
call s:hi("GitGutterDelete",       s:love, "", "")
