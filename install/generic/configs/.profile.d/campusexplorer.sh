
# these are used for mirroring part of the filesystem to the vagrant sandbox
export CE_REMOTE_USERNAME=ketheridge
export CEROOT=~/src/CE
export CE_EMAIL_ADDRESS=ketheridge@campusexplorer.com

export PATH=/Users/ether/src/CE/devtools:/Users/ether/git/CE/devtools:/Users/ether/src/CE/bin:/Users/ether/git/CE/bin:$PATH

ackall() {
    ack "$@" \
        lib t tlib bin root root-admin extlib/etc/modules.yaml
}
