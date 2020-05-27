# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

# Colors and prompt
autoload -U colors && colors
[ -n "$SSH_CLIENT" ] && PS1_HOSTNAME="@$(hostname)"
PS1="%F{blue}λ %1~$PS1_HOSTNAME %f"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh_history

# Autocompletion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Quote pasted URLs automatically
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Make lowercase letters match both lowercase and uppercase letters, but only if no exact matches are found.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Fix common keys
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

# Search history using Up and Down keys
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[5~" history-beginning-search-backward-end
bindkey "^[[6~" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# p shortcut
_accept_line() {
    if [[ $BUFFER = p\ * ]]; then
        python3 ~/.local/lib/p_wrapper.py "${BUFFER#p }"
    fi
    zle .accept-line
}
zle -N accept-line _accept_line
alias p='#'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Clear the screen using C-r
bindkey '^r' clear-screen

# Keep trailing slashes on commands
setopt no_auto_remove_slash

# Allow comments in repl
setopt interactive_comments

# Load other configuration files
[ -f "$HOME/.config/exportrc" ] && source "$HOME/.config/exportrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -f "$HOME/.config/machinerc" ] && source "$HOME/.config/machinerc"

# Load fasd shortcuts
eval "$(fasd --init auto)"
