if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish --cmd cd | source
eval (try init ~/src/tries | string collect)

# if kitty, use printf '\033c' to clear the screen
if test "$TERM" = "xterm-kitty"
    function clear
        printf '\033c'
    end
end

alias x clear
alias v nvim

alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

if status is-interactive
  alias l eza
  alias ls "eza --icons=always --hyperlink"
  alias ll "eza --group --header --group-directories-first --long --hyperlink"
  alias lg "eza --group --header --group-directories-first --long --git --git-ignore --hyperlink"
  alias le "eza --group --header --group-directories-first --long --extended --hyperlink"
  alias lt "eza --group --header --group-directories-first --tree --level 3 --hyperlink"
end

alias ipy "uv run ipython"
alias ipython "uv run ipython"

alias s "kitten ssh"
