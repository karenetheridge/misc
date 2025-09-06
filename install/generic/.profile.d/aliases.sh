# this file is install/generic/.profile.d/aliases.sh

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

alias diff='colordiff  -u -s'

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

spelling() {
    aspell list | sort -u
}

alias rehash='hash -r'

disapprove() {  # ಠ_ಠ
    # unicode: 0x0CA0 0x5F 0x0CA0
    #          \x{0ca0}\x{5f}\x{0ca0}
    # UTF-8:   0xE0 0xB2 0xA0 0x5F 0xE0 0xB2 0xA0
    #          \x{e0}\x{b2}\x{a0}\x{5f}\x{e0}\x{b2}\x{a0}
    #          v224.178.160.95.224.178.160
    perl -CS -E'say v3232.95.3232'
}

snowman () {
    perl -CO -E'say v9731'   # 0x2603
}

heart () {
    perl -CO -E'say v9825'   # 0x2661
}

poo() {
    perl -CO -E'say v128169' # U+1F4A9
}

md5hex() {
    perl -MDigest::MD5=md5_hex -wE'chomp(my $line = <>); say md5_hex($line)'
}

base64 () {
    perl -MDigest::MD5=md5_base64 -wE'chomp(my $line = <>); say md5_base64($line)'
}

rot13(){
    perl -n -wE'tr/A-MN-Za-mn-z/N-ZA-Mn-za-m/; say'
}

maxlen() {
    perl -wE'my $max=0; while (<>) { chomp; my $length = length($_); $max = $length if $length > $max } say $max'
}

perlpie() {
    sub=$1
    shift
    dirs="${@:-lib}"
    perl -p -i -e $sub $(find $dirs -type f)
}

json2yaml() {
    perl -MYAML::XS -MJSON::MaybeXS -wE'$YAML::XS::Boolean="JSON::PP"; print Dump(JSON()->new->allow_nonref->decode(do { local $/; <> }))' $*
}

json2dd() {
    perl -MJSON::MaybeXS -MData::Dumper -wE'print Data::Dumper->new([ JSON()->new->decode(do { local $/; <> }) ] )->Sortkeys(1)->Indent(1)->Terse(1)->Dump' $*
}

yaml2json() {
    perl -MYAML::XS -MJSON::MaybeXS -wE'print JSON()->new->pretty->indent_length(2)->canonical->allow_nonref->encode(Load(do { local $/; <> }))' $*
}

yaml2dd() {
    perl -MYAML::XS -MData::Dumper -wE'print Data::Dumper->new([ Load(do { local $/; <> })] )->Sortkeys(1)->Indent(1)->Terse(1)->Dump' $*
}

dd2yaml() {
    perl -MYAML::XS -MData::Dumper -wE'$YAML::XS::Boolean="JSON::PP"; print Dump(eval do { local $/; <> })' $*
}

# pure-perl json format, 4 columns:
# perl -MJSON::PP -wE'print JSON::PP->new->pretty->indent_length(4)->canonical->encode(JSON::PP->new->decode(do { local $/; <> }))' $*
json2json() {
    perl -MJSON::MaybeXS -wE'print JSON()->new->pretty->indent_length(2)->canonical->encode(JSON()->new->decode(do { local $/; <> }))' $*
}

# re-sorts the provided .json files
jsonsort () {
  perl -MJSON::MaybeXS -0777 -p -i -e'my $encoder = JSON::MaybeXS->new(canonical=>1, pretty=>1, indent_length=>4, utf8=>1); $_ = $encoder->encode($encoder->decode($_));' $*
}

ini2yaml() {
    perl -MConfig::INI::Reader -MYAML::XS -wE'$YAML::XS::Boolean="JSON::PP"; print Dump(Config::INI::Reader->read_string(do { local $/; <> }))' $*
}

# something that I can pipe to that reverses the order of all lines.
reverse_lines () {
  perl -wE'print reverse <>'
}

# shellquote!
sq () {
  jq --raw-output --raw-input '. | @sh'
}

bee () {
  ack -h --nocolor "\\b[$1]+\\b\\W*$" ~/bee* | ack --nocolor $2 | perl -p -e's/\W/\n/g' | ack --nocolor '\w{4}' | sort -u
}

reverse () {
  perl -wle 'local $/; print join "\n", reverse split /\n/, <>'
}
