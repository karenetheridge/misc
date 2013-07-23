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


# perform action (or just print files) on tree, ignoring svn stuff
f () {
    find . \
        -name .svn -a -prune -o \
        -name CVS -a -prune -o \
        $* -print
}

# common operation: print all files from <foo>|$CWD downwards
ff() {
    if [ $1 ]
    then
        DIR=$1
    else
        DIR=.
    fi

    find $DIR \
        -name .svn -a -prune -o \
        -name CVS -a -prune -o \
        -type f -print
}

# just like grep -r <term>, except ignores .svn stuff, vim swap files
s () {
    find . \
        -name .svn -a -prune -o \
        -name blib -a -prune -o \
            -not -name .\*swp \
            -type f \
            -exec grep -i -H "$1" \{\} \;
}

scs () {
    find . \
        -name .svn -a -prune -o \
        -name blib -a -prune -o \
            -not -name .\*swp \
            -type f \
            -exec grep -H "$1" \{\} \;
}

# Touch a file, but create all the intermediate paths first
touchp()
{
    mkdir -p `dirname $1`; touch $1
}

# diff with all the arguments needed to make a patch
diffp()
{
    diff --unified=3 $*
}

build()
{
    make clean; perl Makefile.PL; make
}

pM()
{
    perl Makefile.PL
}

M()
{
    make
}

Mc()
{
    make clean
}

Mt()
{
    make test
}





####### Dec 2009: Tequila

path() {
    perl -wle'print join "\n", split(":", $ENV{PATH})'
}

alias diff='colordiff  -u -s --ignore-blank-lines --ignore-all-space'

alias sidediff='colordiff  -s --side-by-side --width=165 --ignore-all-space'

# use gnu-units rather than /usr/bin/units
alias units=gunits

alias temp='/Applications/TemperatureMonitor.app//Contents/MacOS/tempmonitor -a -l | grep "BATTERY POSITION 2"'
