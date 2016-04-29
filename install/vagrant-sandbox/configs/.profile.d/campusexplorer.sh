
export CE_REMOTE_USERNAME=ketheridge
export CEROOT=/vagrant
export CE_EMAIL_ADDRESS=ketheridge@campusexplorer.com
export CE_SSH_TIMEOUT=120

eval $(perl -Mlocal::lib=/vagrant/extlib)

export CHEOPSROOT=/home/vagrant/git/cheops

export PATH=/vagrant/devtools:/vagrant/bin:$PATH

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

