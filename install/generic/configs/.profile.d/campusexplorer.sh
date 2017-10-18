
export CE_HOST_USERNAME=ether
export CE_REMOTE_USERNAME=ketheridge
export CEROOT=~/src/CE

# for host-to-guest mounting:
export CE_VAGRANT_VBOXSF_MOUNTPOINT=~/src/CE

# for guest-to-host mounting:
# export CE_VAGRANT_SSHFS_MOUNTPOINT=...

export CHEOPSROOT=~/src/cheops
export CE_EMAIL_ADDRESS=ketheridge@campusexplorer.com
export CE_SSH_TIMEOUT=120

export AWS_CONFIG_FILE=$HOME/.aws-campusexplorer/aws.config

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

# overrides the less usable version in devtools/cessh
cessh() {
    host=$1; shift
    ssh -p 8822 -l $CE_REMOTE_USERNAME $host.campusexplorer.com "$@"
}

cescp() {
    host=$1; shift
    scp -P 8822 -l $CE_REMOTE_USERNAME $host.campusexplorer.com "$@"
}

aws_upload() {
    filename="$1"
    zip $filename.zip $filename

    # only zip if does not end in .zip or .gz
    if ! [[ $filename =~ \.(zip|gz)$ ]]; then
        echo zipping $filename to $filename.zip...
        zip $filename.zip $filename
        filename=$filename.zip
    fi

    # aws s3 cp $filename.zip s3://tmp.campusexplorer.com
    # bin/s3-authenticated-url --expires 1440 tmp.campusexplorer.com/`basename $filename.zip`

    s3file=ether/$filename
    s3bucket=download.campusexplorer.com
    expires=$((60 * 60 * 24 * 1)) # 1 day
    region=us-east-1

    aws s3 cp $filename s3://$s3bucket/$s3file

    AWS_ACCESS_KEY_ID=$(aws ssm get-parameters \
      --region "$region" \
      --names /external/s3download/awscreds \
      --with-decryption \
      --query 'Parameters[].Value' \
      --output text | sed 's/:.*//')

    AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameters \
      --region "$region" \
      --names /external/s3download/awscreds \
      --with-decryption \
      --query 'Parameters[].Value' \
      --output text | sed 's/.*://')

    aws s3 presign \
      --expires-in $expires \
      s3://$s3bucket/$s3file

    tput bel
}

build_jenkins() {
    job='ether-testbed-12.04'
    branch="${1:-$(git branchname)}"    # [alias] branchname = rev-parse --abbrev-ref HEAD

    echo kicking off a jenkins build for $branch on $job

    # curl --insecure --silent -X POST "https://localhost/job/$job/build" \
    #         --data-urlencode json='{"parameter": [{"name":"branch", "value":"'$branch'"}]}'

    ssh jenkins.campusexplorer.com ./build_jenkins "$job" "$branch"
}

build_jenkins_xenial() {
    job='ether-testbed-16.04'
    branch="${1:-$(git branchname)}"    # [alias] branchname = rev-parse --abbrev-ref HEAD

    echo kicking off a jenkins build for $branch on $job

    # curl --insecure --silent -X POST "https://localhost/job/$job/build" \
    #         --data-urlencode json='{"parameter": [{"name":"branch", "value":"'$branch'"}]}'

    ssh jenkins.campusexplorer.com ./build_jenkins "$job" "$branch"
}

# on any elasticsearch cluster host...
# note you can also make tunnels; go to http://localhost:9210/_plugin/head/
# for the health of the zora cluster as a whole.
es_health() {
    curl -XGET http://localhost:9200/_cluster/health?pretty=1
}
