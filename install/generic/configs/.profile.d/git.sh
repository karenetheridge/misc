
# aliases and customizations for git
alias gdd='git diff'
alias gds='git diff --staged'

alias gpr='git pull --rebase'
alias grc='git rebase --continue'

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# this is only valid for OSX, but harmless to include everywhere...
export PATH=$PATH:/opt/local/share/git-core/contrib/workdir

# perform command(s) in each repository in 'mydists' sequentially.
mydists() {
    local COMMANDS=$*
    for dir in ~/git/mydists/*; do
        pushd $dir
        echo "executing: $COMMANDS"
        eval $COMMANDS
        popd
    done
}

adopteddists() {
    local COMMANDS=$*
    for dir in ~/git/adopteddists/*; do
        pushd $dir
        echo "executing: $COMMANDS"
        eval $COMMANDS
        popd
    done
}
