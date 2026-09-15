# vim, built to feel like a light nvim/LazyVim: nixpkgs plugins wired in at
# build time (no vim-plug, no curl on first run), the old .vimrc options, and
# fzf/tmux-navigator/git plugins. No LSP - that is what keeps it lighter.
{ pkgs, lib, ... }:
let
  pick = name: lib.optional (builtins.hasAttr name pkgs.vimPlugins) pkgs.vimPlugins.${name};

  plugins = builtins.concatLists [
    (pick "fzf-vim")
    (pick "fzf-wrapper")
    (pick "vim-tmux-navigator")
    (pick "vim-commentary")
    (pick "vim-surround")
    (pick "vim-fugitive")
    (pick "vim-gitgutter")
    (pick "vim-polyglot")
    (pick "undotree")
    (pick "vim-sleuth")
    (pick "indentLine")
  ];

  vim = pkgs.vim-full.customize {
    name = "vim";
    vimrcConfig = {
      customRC = builtins.readFile ../config/vim/vimrc;
      packages.bootxnix.start = plugins;
    };
  };
in
{
  environment.systemPackages = [ vim pkgs.fzf pkgs.ripgrep ];

  # Default editor is set via EDITOR/VISUAL in modules/shell.nix. We do NOT use
  # `programs.vim` here: it would install nixpkgs' plain vim and collide with the
  # customized `vim` package above.

  # The colorscheme lives outside the plugin set (it is a plain runtime file),
  # so drop it where vim's default runtimepath finds it.
  environment.etc."vim/colors/rose-pine.vim".source = ../config/vim/colors/rose-pine.vim;

  environment.variables.MANPAGER = "vim +MANPAGER --not-a-term -";
}
