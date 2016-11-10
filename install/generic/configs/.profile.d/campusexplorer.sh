
export CE_REMOTE_USERNAME=ketheridge
export CEROOT=~/src/CE
export CE_EMAIL_ADDRESS=ketheridge@campusexplorer.com
export CE_SSH_TIMEOUT=120

export CE_MONDAYS_STYLE=safe

export PATH=/Users/ether/src/CE/devtools:/Users/ether/git/CE/devtools:/Users/ether/src/CE/bin:/Users/ether/git/CE/bin:$PATH

export DEVEL_CONFESS_OPTIONS=objects,better_names,color,errors,warnings

ackall() {
    ack "$@" \
        lib t tlib bin devtools root root-admin extlib database push-tasks.d doc
}

export database=localdev
export target_db=localdev

db_credentials() {
    config-db-value $1 db_host db_name db_user db_port db_password
}

dsn() {
    perl -Ilib -MCE::Config -wle'print CE::Config->dsn($ARGV[0] // q{localdev}, $ARGV[1] // q{cedev})' $1 $2
}

ceflow() {
    tput bel
    tput bel
    echo "tried to run: ceflow $*"
    tput bel
    tput bel
}
