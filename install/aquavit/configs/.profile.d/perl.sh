# this file is install/aquavit/configs/.profile.d/perl.sh

source /Users/ether/git/misc/install/generic/configs/.profile.d/perl.sh

export CPAN_META_JSON_BACKEND=

unset PERL_USE_UNSAFE_INC

# some things, e.g. DBD::Pg, don't parallelize well in tests
export HARNESS_OPTIONS=j1:c
