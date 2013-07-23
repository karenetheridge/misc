export EDITOR=vim

# use ANSI color sequences in 'ls', even when outputting to non-tty
export CLICOLOR=1

# I'm not sure why I want this one though??? is it wise?
# e.g https://rt.perl.org/rt3/Public/Bug/Display.html?id=114312
#export CLICOLOR_FORCE=1

export PAGER='less -icMR'
export MANPAGER='less -sicMR'
export PERLDOC_PAGER='less -sicMr'

export HISTTIMEFORMAT="%Y-%m-%d %T  "

LANG=en_US
# LANG=en_US.ISO-8859-1   suggests http://wiki.mutt.org/?MuttFaq/Charset

export LESS="-icMR"
#export LESSCHARSET="latin1"
export LESSCHARSET="utf-8"

# tab-completion ignore
export FIGNORE="CVS:~:.o:.svn:.swp"

# commented out -- I don't need lots of "you have mail in.." alerts
# export MAIL=/Users/ether/mail/i

# be protective!  ... actually this is annoying when changing to root...
#umask 077

# also see zzz.sh - modifies $PATH

