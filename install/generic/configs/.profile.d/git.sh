
# aliases and customizations for git
alias gd='git diff'
alias gdd='git diff $(git describe --abbrev=0 --tags)'
alias gds='git diff --staged'
alias gs='git status'
alias glp='git log -p'
alias gca='git commit --amend'   # not to be confused with 'gcpa' below

alias gpr='git pull --rebase'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias viconf='vim $(git conf)'  # all files in conflict

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# this is only valid for OSX, but harmless to include everywhere...
export PATH=$PATH:/opt/local/share/git-core/contrib/workdir

# perform command(s) in each repository in 'mydists' sequentially.
mydists() {
    local COMMANDS="$@"
    for dir in ~/git/mydists/*; do
        pushd $dir
        echo "executing: $COMMANDS"
        eval $COMMANDS
        popd
    done
}

adopteddists() {
    local COMMANDS="$@"
    for dir in ~/git/adopteddists/*; do
        pushd $dir
        echo "executing: $COMMANDS"
        eval $COMMANDS
        popd
    done
}
