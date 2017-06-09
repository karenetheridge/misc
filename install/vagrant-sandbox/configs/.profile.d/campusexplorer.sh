
export CE_REMOTE_USERNAME=ketheridge
export CEROOT=/vagrant
export CE_EMAIL_ADDRESS=ketheridge@campusexplorer.com
export CE_SSH_TIMEOUT=120

export CE_MONDAYS_STYLE=safe

# make Test::Class print the test names
export TEST_VERBOSE=1

eval $(perl -Mlocal::lib=/vagrant/extlib)

# do this to bring in my other local-lib with extra stuff.
#eval $(perl -Mlocal::lib=/vagrant/etherlib)

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

ceflow() {
    tput bel
    tput bel
    echo "tried to run: ceflow $*"
    tput bel
    tput bel
}

fix_grants() {
    echo 'GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, SHOW VIEW ON `cedev`.* TO "ce_web"@"%"' | devtools/db
}

aws_upload() {
    filename="$1"
    zip $filename.zip $filename
    aws s3 cp $filename.zip s3://tmp.campusexplorer.com
    bin/s3-authenticated-url --expires 1440 tmp.campusexplorer.com/`basename $filename.zip`
    tput bel
}

