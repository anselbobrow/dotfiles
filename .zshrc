export PATH=$HOME/bin:$PATH
export PATH=$PATH:/Users/anselbobrow/Library/Python/3.8/bin
export PATH=$PATH:/usr/local/bin/nvim-osx64/bin

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export ZSH="/Users/anselbobrow/.oh-my-zsh"

PROMPT="%n %. $ "

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
        zsh-autosuggestions
        macos
        nvm
        git
        )

# autosuggestions options
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

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
alias ls="ls -G"

alias emacs="emacs -nw"
alias v="nvim"
alias t="tmux new -A -s 0"
alias vimconf="nvim ~/.vimrc"
alias zshconfig="nvim ~/.zshrc"

alias python="python3"
alias pip="pip3"
alias clang="clang -g -O2 -std=c99"

alias ssh="/Users/anselbobrow/scripts/ssh-ident"
alias scp="BINARY_SSH=scp /Users/anselbobrow/scripts/ssh-ident"
alias zoo="ab3254@node.zoo.cs.yale.edu"

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd"
export FZF_DEFAULT_OPTS="+x -m"
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_COMPLETION_OPTS="+x -m"

# enable iterm shell integration (with tmux)
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

