# this file is install/generic/.profile.d/prompt.sh

# Set Attribute Mode      <ESC>[{attr1};...;{attrn}m
# Sets multiple display attribute settings.
# 0       Reset all attributes
# 1       Bright
# 2       Dim
# 4       Underscore      
# 5       Blink
# 7       Reverse
# 8       Hidden
# 
# Foreground Colours
# 30      Black
# 31      Red
# 32      Green
# 33      Yellow
# 34      Blue
# 35      Magenta
# 36      Cyan
# 37      White
# 
# Background Colours
# 40      Black
# 41      Red
# 42      Green
# 43      Yellow
# 44      Blue
# 45      Magenta
# 46      Cyan
# 47      White
# 
#if ${use_color}; then
 # modifiers go first, then colours.
    blink='\[\e[5m\]'
   invert='\[\e[7m\]'
invisible='\[\e[8m\]'
    black='\[\e[30m\]'
     grey='\[\e[1;30m\]'
      red='\[\e[31m\]'
      RED='\[\e[1;31m\]'
    green='\[\e[32m\]'
    GREEN='\[\e[1;32m\]'
   yellow='\[\e[33m\]'
    brown='\[\e[33m\]'
   YELLOW='\[\e[1;33m\]'
     blue='\[\e[34m\]'
     BLUE='\[\e[1;34m\]'
  magenta='\[\e[35m\]'
  MAGENTA='\[\e[1;35m\]'
     cyan='\[\e[36m\]'
     CYAN='\[\e[1;36m\]'
    white='\[\e[37m\]'
    WHITE='\[\e[1;37m\]'
       NC='\[\e[0m\]'

# experiment thusly:
# echo  -e "\033[5mhello world\033[0m"

##### all this commented out!
if test 0; then

# Root's:
if test -n "$PS1" -a -t 0; then
    if test -n "$WINDOW"; then
      export PS1=': \[\033[01;31m\]\h \[\033[01;34m\]\W].${WINDOW}\$\[\033[00m\]; '
      #             ^^ bold red ^^^   ^^ bold blue ^^             ##^^ normal ^^
      # orig        \[\033[01;31m\]\h \[\033[01;34m\]\W \$ \[\033[00m\]
    else
      export PS1=': \[\033[01;31m\]\h \[\033[01;34m\]\W]\$\[\033[00m\]; '
      #             ^^ bold red ^^^   ^^ bold blue ^^   ##
      # orig        \[\033[01;31m\]\h \[\033[01;34m\]\W \$ \[\033[00m\]
    fi
fi

# Neil's - a little too colourful for me:
# that's green yellow blue yellow
if test -n "$WINDOW"; then
    PS1='\[\033[01;32m\][\u@\[\033[01;33m\]\h:${WINDOW} \[\033[01;34m\]\W\[\033[01;32m\]]\$ \[\033[00m\]'
else
    PS1='\[\033[01;32m\][\u@\[\033[01;33m\]\h \[\033[01;34m\]\W\[\033[01;32m\]]\$ \[\033[00m\]'
fi
export PS1

# Original from .bashrc:

if test -n "$PS1" -a -t 0; then
    if test -n "$WINDOW"; then
      export PS1=': [\u@\h \W].${WINDOW}\$; '
    else
      export PS1=': [\u@\h \W]\$; '
    fi
fi

fi
#### end of noop.

# special circumstances:
# - use 'dirs +0' to get ~ rather than /Users/ether
#   but "dirname ~" gives the wrong results...

#PROMPT_COMMAND="PS1_DIR=\`basename \\\`dirname \\\$PWD\\\`\`/\`basename \$PWD\`"

prompt_function() {
    MY_PWD=`dirs +0`
    PS1_DIR1=`basename "\`dirname \"\$MY_PWD\"\`"`
    PS1_DIR2=`basename "$MY_PWD"`
    SEP=/
    if [ "$PS1_DIR1" = "." ]; then
        unset PS1_DIR1
        SEP=''
    fi
    if [ "$PS1_DIR1" = "/" ]; then unset PS1_DIR1; fi
    if [ "$PS1_DIR2" = "/" ]; then unset PS1_DIR2; fi

    # set window title
    echo -n -e "\033]0;$PS1_DIR2\007"
}

PROMPT_COMMAND="prompt_function"

# test -t 0: checks fd 0 (stdin)
# we filter out $?=141 which is pipefail:
# https://unix.stackexchange.com/questions/582844/how-to-suppress-sigpipe-in-bash
# https://unix.stackexchange.com/questions/274120/pipe-fail-141-when-piping-output-into-tee-why
if test -t 0; then
    P1="${yellow}:${NC} \$(if [[ \$? != 0 && \$? != 141 && \$? != 146 ]]; then printf \"${yellow}\"; fi)[\u@\h \$PS1_DIR1\$SEP\$PS1_DIR2]"
    P2="\$${yellow};${NC} "
    if test -n "$WINDOW"; then
      export PS1="${P1}.\${WINDOW}${P2}"
    else
      export PS1="${P1}${P2}"
    fi
fi


