# this file is install/generic/configs/.bashrc

# note this gets run via .bash_profile too

for SHFILE in $HOME/.profile.d/*sh; do
#    echo sourcing $SHFILE
    source $SHFILE
#    echo PATH is now $PATH
done

