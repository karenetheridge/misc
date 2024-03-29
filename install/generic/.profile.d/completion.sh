# this file is install/generic/.profile.d/completion.sh

# bash shell completion

# completion for Makefile targets
# see http://stackoverflow.com/a/38415982/1472048
complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make

# enable extended globbing! (see 'extglob' in man bash)
shopt -s extglob
