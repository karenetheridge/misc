
# note this gets run via .bash_profile too

# save original PATH...
orig_PATH=$PATH

#echo orig PATH: $PATH

for SHFILE in $HOME/.profile.d/*sh; do
#    echo sourcing $SHFILE
    source $SHFILE
#    echo PATH is now $PATH
done

export PATH=`perl -MList::MoreUtils=uniq -wle'print join(":", uniq split(":", $ENV{PATH}))'`

#echo new PATH: $PATH

# now restore original values if no new information has been added (but simply
# the order shuffled around - which had pushed values we wanted at the top
# closer to the end)

perl -wle'
    my $old = join(":",sort split(/:/, $ARGV[0]));
    my $new = join(":",sort split(/:/, $ARGV[1]));
#print "### old: $old.\n### new: $new.\n";
    exit (($old eq $new) ? 0 : 1)' $orig_PATH $PATH

#if [[ ${#PATH} == ${#orig_PATH} ]]; then
if [ $? -eq 0 ]; then
#echo comparison returned exit value $?
    #echo "PATH is same length as orig_PATH - restoring original order"
    export PATH=$orig_PATH
fi

#echo final PATH: $PATH

