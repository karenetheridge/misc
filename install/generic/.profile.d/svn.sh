# this file is install/generic/.profile.d/svn.sh

# print description of change (legacy name from Luke)..
# pdes 4   -> prints info about rev 4
#              svn log -v -r 4
#              svn diff -r 3:4
pdes() {
    REV=$1
    PATHNAME=${2-}
    OLDREV=$(expr $REV - 1)
    svn log -v -r $REV $PATHNAME
    svn diff -r $OLDREV:$REV $PATHNAME
}

# info about diffs between two different versions
# pdes2 4 6 -> prints info about changes between 4 and 6 (or say 4: to mean 4 to current)
#              svn log -v -r 5:6    ??
#              svn diff -r 4:6      ??
# pdes2 4  ->  svn log -v -r 4:HEAD ??
#              svn diff -r 3:HEAD   ??
# problem if other changes to the repo were made that don't involve this tree!!!

pdes2() {
    # REV1=$(echo $1 | cut -d : -f 1)
    # REV2=$(echo $1 | cut -d : -f 2)
    REV1=$1
    REV2=$2
    PATHNAME=${3-}

    ENDREV=$REV2
    if [[ ! $ENDREV =~ "HEAD" ]]; then
        ENDREV=$(expr $REV2 - 1)
    fi

    svn log -v -r $REV1:$ENDREV $PATHNAME
    svn diff -r $(expr $REV1 - 1):$ENDREV $PATHNAME
}




# other aliases needed:

# - equivalent of p4 integrate -n foo/... bar/...
# (show me pending diffs between two branches)

# - see perforce.sh - e.g. p4pending, etc (stuff that understands recursive
# branching layout)


