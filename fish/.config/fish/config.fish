zoxide init fish --cmd cd | source
starship init fish | source
atuin init fish | source

# if kitty, use printf '\033c' to clear the screen
if test "$TERM" = "xterm-kitty"
    function clear
        printf '\033c'
    end
end

alias rm trash
alias x clear
alias v nvim
alias g "glow -w $COLUMNS"

alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

alias l eza
alias ls "eza --icons=always --hyperlink"
alias ll "eza --group --header --group-directories-first --long --hyperlink"
alias lg "eza --group --header --group-directories-first --long --git --git-ignore --hyperlink"
alias le "eza --group --header --group-directories-first --long --extended --hyperlink"
alias lt "eza --group --header --group-directories-first --tree --level 3 --hyperlink"

alias ipy ipython
bind \cs __ethp_commandline_toggle_sudo

alias s "kitten ssh"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
