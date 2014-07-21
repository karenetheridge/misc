
# these are used for mirroring part of the filesystem to the vagrant sandbox
export CE_REMOTE_USERNAME=ketheridge
export CEROOT=~/src/CE
export CE_EMAIL_ADDRESS=ketheridge@campusexplorer.com

export PATH=/Users/ether/src/CE/devtools:/Users/ether/git/CE/devtools:/Users/ether/src/CE/bin:/Users/ether/git/CE/bin:$PATH

ackall() {
    ack "$@" \
        lib t tlib bin root root-admin extlib
}

export database=localdev
export target_db=localdev

db_credentials() {
    perl bin/config-db-value $1 db_host db_name db_user db_port db_password
}

dsn() {
    perl -Ilib -MCE::Config -wle'print CE::Config->dsn($ARGV[0] // q{localdev}, $ARGV[1] // q{cedev})' $1 $2
}
