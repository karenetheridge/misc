# this file is install/generic/configs/.profile.d/env.sh

export EDITOR=vim

# use ANSI color sequences in 'ls', even when outputting to non-tty
export CLICOLOR=1

# I'm not sure why I want this one though??? is it wise?
# e.g https://rt.perl.org/rt3/Public/Bug/Display.html?id=114312
#export CLICOLOR_FORCE=1

export PAGER='less -icMR'
export MANPAGER='less -sicMR'
export PERLDOC_PAGER='less -sicMr'

export PERLDOC=-oman    # xdg++, fixes https://rt.cpan.org/Public/Bug/Display.html?id=88204

export HISTTIMEFORMAT="%Y-%m-%d %T  "
export HISTSIZE=10000
export HISTCONTROL=ignoredups   # turn off ignorespace

export LANG=en_CA.UTF-8
#export LC_ALL=en_CA.UTF-8


export LESS="-icMR"
#export LESSCHARSET="latin1"
export LESSCHARSET="utf-8"

# tab-completion ignore
export FIGNORE="CVS:~:.o:.svn:.swp"

# suppress warning at login:
#   The default interactive shell is now zsh.
#   To update your account to use zsh, please run `chsh -s /bin/zsh`.
#   For more details, please visit https://support.apple.com/kb/HT208050.
export BASH_SILENCE_DEPRECATION_WARNING=1

# commented out -- I don't need lots of "you have mail in.." alerts
# export MAIL=$HOME/mail/i

# be protective!  ... actually this is annoying when changing to root...
#umask 077

# also see zzz.sh - modifies $PATH

