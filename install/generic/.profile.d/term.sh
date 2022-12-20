# this file is install/generic/.profile.d/term.sh

if [[ ! $TERM =~ "vt100" ]]; then
    export TERM=xterm-color
fi

