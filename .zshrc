# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# set up homebrew
export PATH=$PATH:$HOME/.toolbox/bin
eval $(/opt/homebrew/bin/brew shellenv)

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cloud" # set by `omz`
export LS_COLORS=$(vivid generate gruvbox-dark)

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git colored-man-pages zsh-autosuggestions tmux sudo brew aliases)

# Completion setup
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
rm -f $ZSH_COMPDUMP

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# use vivid generated colors for ls and autocompletion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
alias ls="gls --color"

# aliases
alias v="nvim"
alias t2="tree -I node_modules -L 2"
alias t5="tree -I node_modules -L 5"
alias zfg="v ~/.zshrc"
alias gg="lazygit"
alias tp="trash-put"

# fzf config
export FZF_ALT_C_COMMAND="fd -t d \
  -E Library \
  --search-path /Users/ansel/"
source <(fzf --zsh)
