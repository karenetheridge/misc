# this file is install/generic/.bashrc

# note this gets run via .bash_profile too

for SHFILE in $HOME/.profile.d/*sh; do
#    echo sourcing $SHFILE
    source $SHFILE
#    echo PATH is now $PATH
done

