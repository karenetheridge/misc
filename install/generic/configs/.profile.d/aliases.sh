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

alias diff='colordiff  -u -s --ignore-blank-lines'

alias sidediff='colordiff  -s --side-by-side --width=165'

# use gnu-units rather than /usr/bin/units
alias units=gunits

alias temp='/Applications/TemperatureMonitor.app//Contents/MacOS/tempmonitor -a -l | grep "BATTERY POSITION 2"'
