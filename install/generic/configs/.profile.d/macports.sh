
# (moved from .bash_profile where it was put automatically):

# MacPorts Installer addition on 2012-03-10_at_09:51:50: adding an appropriate PATH variable for use with MacPorts.
# export PATH=/opt/local/bin:/opt/local/sbin:$PATH

prepend_path_uniq /opt/local/sbin /opt/local/bin

# Finished adapting your PATH environment variable for use with MacPorts.

############### manual additions below this point:

# not needed: PATH is used to figure out where to go.
#export MANPATH=/opt/local/man:$MANPATH

# for a list of what ports I explicitly requested:
# port installed requested

# https://guide.macports.org/chunked/using.common-tasks.html

macportsup() {
    # update macports itself
    echo ""
    echo "executing: \"sudo port -v selfupdate\""
    tput bel
    sudo port -v selfupdate

    # upgrade everything already installed
    echo ""
    echo "executing: \"sudo port upgrade outdated\""
    tput bel
    sudo port upgrade outdated

    echo "if you are extremely happy with the results, or need disk space, run macportscleanup"
    say "macports update complete"
}

macportscleanup() {
    # uninstall dependencies that are no longer needed
    echo ""
    echo "executing: \"sudo port_cutleaves\""
    tput bel
    sudo port_cutleaves

    # uninstall inactive things
    echo ""
    echo "executing: \"sudo port uninstall inactive\""
    tput bel
    sudo port uninstall inactive

    echo ""
    echo "need more disk space? run repeatedly until there is nothing more to do:"
    echo "macportscleanup"
    say "macports cleanup complete"
}

alias macportsupdate=macportsup
alias macportsupgrade=macportsup

# more commands to do periodically:
#  http://guide.macports.org/chunked/using.common-tasks.html
# sudo port uninstall inactive
# sudo port echo leaves  -> port installed leaves -> port uninstall leaves


# added at the request of git +bash_completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi
