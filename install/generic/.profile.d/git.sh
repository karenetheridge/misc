# this file is install/generic/.profile.d/git.sh

# see also install/generic/.gitconfig
# for more aliases

# aliases and customizations for git
alias gd='git diff --word-diff=color'
alias gdd='git diff --word-diff=color $(git describe --abbrev=0 --tags) HEAD' # committed changes since last tag
alias gds='git diff --word-diff=color --staged'
alias gdo='git diff @{u}'
alias gs='git status'
alias gsi='git status --ignored'
alias glp='git log -p --decorate --notes --pretty=fuller --stat'
alias glpd='git log -p --reverse $(git describe --abbrev=0 --tags)..HEAD'
alias gl='git log --decorate --notes --graph --pretty=fuller --stat'
alias gtc='git tag --contains'

alias gca='git commit -v --amend'   # not to be confused with 'gcpa' below
alias gc='git commit -v'

alias gcp='git cherry-pick --ff'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'

alias gpr='git pull --rebase'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gri='git rebase -i $(git describe --abbrev=0 --tags)'
alias viconf='vim $(git conf)'  # edit all files in conflict - see .gitconfig alias
alias gco='git checkout'
alias gcop='git checkout -p'

stash() {
  git show "stash@{${1:-0}}"
}

gcm () {
    git commit -m"$*"
}

sq () {
    git commit -m"squash! $*"
}

fixup () {
    git commit -m"fixup! $*"
}

gbi() {
  # first arg, defaulting to 2; all args after the first
  git rebase -i "HEAD~${1:-2}" "${@: 2}";
}

alias gitalltags='git log --tags --simplify-by-decoration --notes --pretty="format:%ai %d"'

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# this is only valid for OSX, but harmless to include everywhere...
export PATH=$PATH:/opt/local/share/git-core/contrib/workdir

# perform command(s) in each repository in '_mydists' sequentially.
mydists() {
    local COMMANDS="$@"
    for dir in ~/git/_mydists/*; do
        pushd $dir
        echo "executing: $COMMANDS"
        eval $COMMANDS
        popd
    done
}

adopteddists() {
    local COMMANDS="$@"
    for dir in ~/git/_adopteddists/*; do
        pushd $dir
        echo "executing: $COMMANDS"
        eval $COMMANDS
        popd
    done
}
