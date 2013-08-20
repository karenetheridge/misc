
# aliases and customizations for git
alias gdd='git diff'

alias gpr='git pull --rebase'

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# this is only valid for OSX, but harmless to include everywhere...
export PATH=$PATH:/opt/local/share/git-core/contrib/workdir
