#!/bin/bash

mkdir -p ~/.config

ln -sf ~/dotfiles/tmux ~/.config/
ln -sf ~/dotfiles/nvim ~/.config/
ln -sf ~/dotfiles/wezterm ~/.config/


arch=$(uname -m)

case $(uname -m) in
    x86_64)
        paru -Sy bash zoxide fzf fd ripgrep wezterm
        ;;
    *)
        NONINTERACTIVE=1 brew install bash zoxide fzf fd ripgrep wezterm
        ;;
esac
