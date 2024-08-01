# load zgen
source "${HOME}/.zgen/zgen.zsh"
#
# export NVM_LAZY_LOAD=true

# if the init script doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/sudo
  zgen oh-my-zsh plugins/node
  zgen oh-my-zsh plugins/command-not-found
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh themes/gozilla
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions
  # generate the init script from plugins above
  zgen save
fi

export PATH=~/.local/bin:$PATH

export PNPM_HOME=""
set -o vi

# Load Angular CLI autocompletion.
#source <(ng completion script)

# export NODE_PATH=$NODE_PATH:`npm root -g`

eval "$(mise hook-env)"
# source "$HOME/.cargo/env"
