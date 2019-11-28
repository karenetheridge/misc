# this file is install/aquavit/configs/.profile.d/conch.sh

# this should be automatic, but see https://trac.macports.org/ticket/50058
export PATH=$PATH:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin

# see https://stackoverflow.com/questions/11618898/pg-config-executable-not-found
# allows pg_config to be found and run, to set POSTGRES_* environment variables
export PATH=$PATH:/opt/local/lib/postgresql10/bin

# from buildops-docs/setup/mac/
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH


conch_db() {
    sudo -u postgres psql -U conch
}

conch_versions() {
    echo prod: $(curl --silent https://conch.joyent.us/version)
    echo staging: $(curl --silent https://staging.conch.joyent.us/version)
}
