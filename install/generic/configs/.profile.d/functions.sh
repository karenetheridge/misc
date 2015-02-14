
mtime() {
    perl -wle'open my $fh, "<", $ARGV[0]; print +(stat($fh))[9];'
}

atime() {
    perl -wle'open my $fh, "<", $ARGV[0]; print +(stat($fh))[8];'
}


title() {
    printf "\033]0;%s\007" "$1"
}

# find non-ascii content
alias ackutf8='ack "[^[:ascii:]]"'
alias nonascii='ack "[^[:ascii:]]"'

alias crontab="VIM_CRONTAB=true crontab"
