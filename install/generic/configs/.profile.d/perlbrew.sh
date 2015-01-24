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

# another alternative to try: if [ $SHLVL -eq 1 ]; then...
# or, do not run if $PERLBREW_ROOT is already set.

# the same song-and-dance is done with PATH in .bashrc directly, as many
# files change PATH

# remove duplicates, for comparison

#command -v foo >/dev/null 2>&1 && {
#    export PERL5LIB=`perl -MList::MoreUtils=uniq -wle'print join(":", uniq split(":", $ENV{PERL5LIB} // ""))'`
#}

# save original PERL5LIB...
orig_PERL5LIB=$PERL5LIB

#echo orig PERL5LIB: $orig_PERL5LIB

source ~/perl5/perlbrew/etc/bashrc

#export PERL5LIB=`perl -MList::MoreUtils=uniq -wle'print join(":", uniq split(":", $ENV{PERL5LIB}))'`

#echo new PERL5LIB: $PERL5LIB

# now restore original values if no new information has been added (but simply
# the order shuffled around - which had pushed values we wanted at the top
# closer to the end)

perl -wle'
    my $new = join(":",sort split(/:/, $ARGV[0]));
    my $old = join(":",sort split(/:/, $ARGV[1] // ""));
#print "### old: $old.\n### new: $new.\n";
    exit (($old eq $new) ? 0 : 1)' $PERL5LIB $orig_PERL5LIB

#if [[ ${#PERL5LIB} == ${#orig_PERL5LIB} ]]; then
if [ $? -eq 0 ]; then
#echo comparison returned exit value $?
#echo "PERL5LIB is same length as orig_PERL5LIB - restoring original order"
    export PERL5LIB=$orig_PERL5LIB
fi

#echo final PERL5LIB: $PERL5LIB

#
# For further instructions, simply run `perlbrew` to see the help message.
#
# Happy brewing!

