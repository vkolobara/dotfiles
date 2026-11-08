for prefix in /opt/homebrew /home/linuxbrew/.linuxbrew
    if test -d $prefix/bin
        fish_add_path --path $prefix/bin $prefix/sbin
        if test -x $prefix/bin/brew
            $prefix/bin/brew shellenv fish | source
        end
        break
    end
end

fish_add_path "$HOME/.cargo/bin" "$HOME/go/bin"
for extra in "$HOME/.spicetify" "$HOME/.config/emacs/bin"
    test -d "$extra"; and fish_add_path "$extra"
end

# Keep mise ahead of Homebrew, system packages, and inherited runtime-manager paths.
set -l mise_data_dir "$HOME/.local/share/mise"
if set -q XDG_DATA_HOME
    set mise_data_dir "$XDG_DATA_HOME/mise"
end
if set -q MISE_DATA_DIR
    set mise_data_dir "$MISE_DATA_DIR"
end
fish_add_path --path --prepend --move "$mise_data_dir/shims" "$HOME/.local/bin"

# Prefer package-manager Atuin over an inherited standalone installation.
fish_add_path --path --append --move "$HOME/.atuin/bin"

set -gx EDITOR nvim
set -gx VISUAL nvim

# Mise owns Cursor CLI updates.
function cursor-agent --description 'Run Cursor CLI without its built-in updater'
    command cursor-agent --disable-auto-update $argv
end

if status is-interactive
    # config.fish runs after conf.d, including Fish's migrated color settings.
    source "$__fish_config_dir/kanagawa.fish"
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=bg:#1f1f28,fg:#dcd7ba,bg+:#2d4f67,fg+:#dcd7ba,hl:#7e9cd8,hl+:#7fb4ca,border:#54546d,info:#c0a36e,prompt:#957fb8,pointer:#7fb4ca,marker:#98bb6c,spinner:#957fb8,header:#7aa89f"
    command -q mise; and mise activate fish | source
    command -q atuin; and atuin init fish | source
    command -q zoxide; and zoxide init fish | source
end

if command -q keychain
    if status is-interactive
        set -l keys
        for key in "$HOME"/.ssh/id "$HOME"/.ssh/id2 "$HOME"/.ssh/id_*
            if test -f "$key"; and not string match -q '*.pub' -- "$key"
                set -a keys "$key"
            end
        end
        test (count $keys) -eq 0; or keychain --eval --quiet $keys | source
    else if status is-login
        keychain --eval --quiet --noask | source
    end
end
