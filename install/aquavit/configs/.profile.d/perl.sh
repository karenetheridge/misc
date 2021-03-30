# this file is install/aquavit/configs/.profile.d/perl.sh

source /Users/ether/git/misc/install/generic/configs/.profile.d/perl.sh

export CPAN_META_JSON_BACKEND=

# use maximal failure mode for now
# (when left unset, cpanm enables it -- maybe safer for carton, but I still
# want to know which distributions are misbehaving)
#unset PERL_USE_UNSAFE_INC
