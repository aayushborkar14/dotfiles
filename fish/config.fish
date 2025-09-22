if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source
alias cd="z"
starship init fish | source

set fish_greeting
# function fish_greeting
#     pokemon-colorscripts --no-title -n kyogre
# end

bind \cs __ethp_commandline_toggle_sudo
abbr -a .. cd ../
abbr -a ... cd ../../
abbr -a .... cd ../../../
abbr -a ..... cd ../../../../
