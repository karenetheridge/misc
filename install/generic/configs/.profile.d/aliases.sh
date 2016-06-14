# This file is intentionally loaded first or nearly-first out of all .sh files

alias l='less -S'
alias m='less'
alias dir='ls -l'
alias dos2unix='perl -spi -e"s|\r\$||"'
alias unix2dos='perl -spi -e"s|\$|\r|"'
alias svim='sudo vim'

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'


inlinesort () {
    sort -dfu -o $1 $1
}

# Touch a file, but create all the intermediate paths first
touchp()
{
    mkdir -p `dirname $1`; touch $1
}

# diff with all the arguments needed to make a patch
diffp()
{
    diff --unified=3 $@
}



####### Dec 2009: Tequila

path() {
    perl -wle'print join "\n", split(":", $ENV{PATH})'
}

alias diff='colordiff  -u -s --ignore-blank-lines'

alias sidediff='colordiff  -s --side-by-side --width=165'

# use gnu-units rather than /usr/bin/units
alias units=gunits

alias temp='/Applications/TemperatureMonitor.app//Contents/MacOS/tempmonitor -a -l | grep "BATTERY POSITION 2"'




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



# append paths to $PATH, only if they are not already present
append_path_uniq() {
    for value in $*; do
        if [[ :$PATH: != *:$value:* ]] ; then
            export PATH="$PATH:$value"
        fi
    done
}

# append paths to $PATH, only if they are not already present
# (last entry appears first in the final $PATH)
prepend_path_uniq() {
    for value in $*; do
        if [[ :$PATH: != *:$value:* ]] ; then
            export PATH="$value:$PATH"
        fi
    done
}

no() {
    perl -e'for (;;) { print "n\n" }'
}

