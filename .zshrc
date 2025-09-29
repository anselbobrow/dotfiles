export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cloud"
export LS_COLORS=$(vivid generate gruvbox-dark)

# use vivid generated colors for autocompletion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# fzf config
export FZF_ALT_C_COMMAND="fd -t d \
  --search-path /home/ansel/"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  git
  tmux
  fzf
  sudo
  aliases
  docker-compose
  colored-man-pages
  zsh-autosuggestions
)

rm -f $ZSH_COMPDUMP

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# aliases
alias v="nvim"
alias t2="tree -I node_modules -L 2"
alias t3="tree -I node_modules -L 3"
alias t5="tree -I node_modules -L 5"
alias t10="tree -I node_modules -L 10"
alias zfg="v ~/.zshrc"
alias gg="lazygit"
alias tp="trash-put"
