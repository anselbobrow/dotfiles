export PATH=$HOME/bin:$PATH
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export ZSH="$HOME/.oh-my-zsh"

# add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# enable pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
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

# enable homebrew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

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

alias lg="lazygit"
alias top="htop"
alias emacs="emacs -nw"
alias v="nvim"
alias t="tmux new -A -s 0"
alias zshconfig="nvim ~/.zshrc"

alias clang="clang -g -O2 -std=c99"
alias lsusb="ls /dev/cu.*"

alias ssh="$HOME/scripts/ssh-ident"
alias scp="BINARY_SSH=scp $HOME/scripts/ssh-ident"

alias get_idf=". $HOME/esp/esp-idf/export.sh"
alias acli="arduino-cli"
alias acup="arduino-cli compile && arduino-cli upload"

alias l2="tree -L 2"

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd -Ha --base-directory /Users/ansel/ -E .cargo -E Library -E .local -E .cache -E 'iTunes Media' -E Media.localized"
export FZF_DEFAULT_OPTS="+x -m"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_ALT_C_OPTS="--preview 'tree -C -L 5 {}'"
export FZF_COMPLETION_OPTS="+x -m"

# nvm config
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# rack sdk
export RACK_DIR="/Users/ansel/Rack-SDK"

# openssl config
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

# add go bin to path
export PATH=$HOME/go/bin:$PATH

# Created by `pipx` on 2023-01-23 19:28:09
export PATH="$PATH:/Users/ansel/.local/bin"
eval "$(register-python-argcomplete pipx)"

# avert pipenv warning
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# opam init
[[ ! -r /Users/ansel/.opam/opam-init/init.zsh ]] || source /Users/ansel/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
