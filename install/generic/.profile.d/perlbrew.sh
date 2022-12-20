# this file is install/generic/.profile.d/perlbrew.sh

# from perlbrew.pl:
## Installing perlbrew
# The perlbrew is installed as:
#
#    ~/perl5/perlbrew/bin/perlbrew
#
# You may trash the downloaded /private/var/folders/+h/+hzG2W8MHem4qQiRP616jE+++TQ/-Tmp-/perlbrew-29921 from now on.
#
# Perlbrew environment initiated under ~/perl5/perlbrew
#
# Append the following piece of code to the end of your ~/.bash_profile and start a
# new shell, perlbrew should be up and fully functional from there:

# do not add perlbrew to path if already there, so as to avoid overshadowing a
# dzil .build path.

if [ ! -z "$PERLBREW_ROOT" ]; then
    # PERLBREW_ROOT already set - doing nothing
    return;
fi

source ~/perl5/perlbrew/etc/bashrc

#
# For further instructions, simply run `perlbrew` to see the help message.
#
# Happy brewing!

