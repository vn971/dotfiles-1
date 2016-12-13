[[ $TERM == 'dumb' ]] && unsetopt zle && PS1='$ ' && return

# History file
HISTFILE=~/.histfile
# The number of lines the shell will keep within one session
HISTSIZE=20480
# The number of lines of history will be saved
SAVEHIST=8192
PS1='[%n@%m %~]$ '

# Remove all duplicates of current command from history, add current to end
setopt hist_ignore_all_dups
# Don't save any commands beginning with space
setopt hist_ignore_space
# Enable extended globs to interpret things like rm ^(file|file2)
setopt extended_glob
# Don't beep even if zsh don't like something
setopt no_beep
# Change directory even if user forgot to put 'cd' command in front, but entered path is valid
setopt auto_cd
# If possible, correct commands
setopt correct
# Append their history list to the history file, rather than replace it
setopt append_history
# If a pattern for filename generation has no matches, print an error, instead of leaving it unchanged in the argument list
setopt nomatch
# Report the status of background jobs immediately, rather than waiting until just before printing a prompt
setopt notify

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select
# Sets autocompletion
autoload -Uz compinit && compinit

bindkey -e
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export PATH=~/.cabal/bin:$PATH
export EDITOR=nano