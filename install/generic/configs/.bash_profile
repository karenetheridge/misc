
# apparently necessary: .bashrc is not sourced on its own from the default
# 'login', 'bash' sequence?
RCFILE=$HOME/.bashrc
[[ -f $RCFILE ]] && source $RCFILE

