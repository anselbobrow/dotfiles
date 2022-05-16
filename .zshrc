export PATH=$HOME/bin:$PATH
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export ZSH="$HOME/.oh-my-zsh"

# add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# enable pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
# enable rbenv
eval "$(rbenv init - zsh)"

# add cargo to path
source "$HOME/.cargo/env"

# add zsh-autosuggestions to path
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# PROMPT="%n %. $ "

ZSH_THEME="common"
export LS_COLORS=$(vivid generate gruvbox-dark)

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=28

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
 DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
        macos
        git
        )

# autosuggestions options
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias rm="rm -i"
alias ls="gls --color"

alias emacs="emacs -nw"
alias v="nvim"
alias t="tmux new -A -s 0"
alias vimconf="nvim ~/.vimrc"
alias zshconfig="nvim ~/.zshrc"

alias python="python3"
alias pip="pip3"
alias clang="clang -g -O2 -std=c99"

alias ssh="$HOME/scripts/ssh-ident"
alias scp="BINARY_SSH=scp $HOME/scripts/ssh-ident"

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd -H -E .cargo -E Library -E .local"
export FZF_DEFAULT_OPTS="+x -m"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_COMPLETION_OPTS="+x -m"
