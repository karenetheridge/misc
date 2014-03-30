# stuff that runs at the (presumed) end of the .sh startup

# Ensure that this path has the highest precedence
#export PATH=~/bin:/usr/local/bin:$PATH
export PATH=~/bin:~/git/misc/install/$HOSTNAME/bin:~/git/misc/install/generic/bin:$PATH

# remove duplicate $PATH elements
# commented out for now - not needed.
# export PATH=`perl -MList::MoreUtils=uniq -wle'print join(":", uniq split(":", $ENV{PATH}))'`

