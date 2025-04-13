# vim: set ts=8 sts=2 sw=2 tw=100 et ft=bash :
# this file is install/generic/.profile.d/perl.sh

# to alter ExtUtils::MakeMaker options (e.g. compile options used in cpan):
# export PERL_MM_OPT="INC=-I/opt/local/include LIBS=-L/opt/local/lib"

# export PERL_MB_OPT="--install_path bindoc= --install_path libdoc="

# export PATH=/usr/local/ActivePerl-5.8/bin:$PATH

export HARNESS_OPTIONS=j6:c

# used by ExtUtils::Install 1.68+
export PERL_INSTALL_QUIET=1

export NO_NETWORK_TESTING=1

export DZIL_AIRPLANE=1

# see https://metacpan.org/pod/release/MSTROUT/Parse-CPAN-Meta-1.4418-TRIAL/lib/Parse/CPAN/Meta.pm#ENVIRONMENT
export CPAN_META_JSON_BACKEND=JSON::MaybeXS

# used by JSON.pm - but Parse::CPAN::Meta only uses this if
# CPAN_META_JSON_BACKEND is not set and it must be either JSON::PP or
# JSON::XS -- so we cannot use it yet.
# export PERL_JSON_BACKEND=Cpanel::JSON::XS

# if I set this variable to true, I want it to be intentional.
# otherwise, engage maximal failure mode.
# 2024-07-26  try going without to see how things are different?
# export PERL_USE_UNSAFE_INC=0

# added in perl 5.33.5
export PERL_TEST_HARNESS_ASAP=1


# used by EUMM to add things as prereqs, rather than bundling.
# cannot use this when actually installing EUMM into an older perl
#export BUILDING_AS_PACKAGE=1

# ensure version for 'dzil run' subshells does not affect subsequent builds
unset V

# maybe don't do this everywhere... just remember how to do it when we need it.
# careful, if you do this, you will obliterate the INSTALL_BASE setting we
# need for perlbrew.
# PERL_MM_OPT=NORECURS=1

# see App::Nopaste::Command
export NOPASTE_SERVICES='Shadowcat Gist Pastie Snitch'

gist() {
    nopaste --service Gist --private --desc "commandline gist $0" $@
}

# equivalent to perldoc -l <module>
perlwhere() {
    perl -wE'eval "require $ARGV[0]" or die; ($mod = $ARGV[0]) =~ s|::|/|g; say $INC{"${mod}.pm"}' $1
}

perlversion() {
    perl -m$1 -wE'say $ARGV[0]->VERSION' $1
}

# given a class name, dumps its symbol table
dumpsymbols() {
    perl -Ilib -MData::Dumper -MModule::Runtime=use_module -wE'
        local $Data::Dumper::Terse = 1;
        local $Data::Dumper::Sortkeys = 1;
        foreach my $className (@ARGV)
        {
            use_module($className);
            say "symbols in $className:";
            no strict "refs";
            say Dumper(\%{"main::${className}::"});
        }
' $@
}

# Note that perls are installed in /usr/local/perls/ and symlinked into
# /usr/local/bin/perl*


# calculates the rw repository for the given Moose/MX module
# usage:  git clone `gitmo moosex::something` or moosex-something

# http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/Log-Contextual.git
# p5sagit@git.shadowcat.co.uk:Log-Contextual.git
# git://git.shadowcat.co.uk/p5sagit/Log-Contextual.git
gitmo() {
    perl -wE'
        my $dist = shift @ARGV;
        $dist =~ s/::/-/g;
        $dist =~ s/moose/Moose/;
        $dist =~ s/oosex/ooseX/i;
        $dist =~ s/-([a-z])/"-". uc($1)/e;
        say "git://git.moose.perl.org/", $dist, ".git"' $1
}



releases() {
    egrep '(CPAN Upload|Day changed)' irclogs/IRCnet*/#moose.log | less
}

# XXX TODO
#export PERL_CPANM_OPT="--cascade-search --save-dists=$HOME/.cpanm/cache --mirror=$HOME/.cpanm/cache"
#--mirror=http://search.cpan.org/CPAN"

# if App::cpanminus::reporter is installed, we send reports automatically
#alias cpanm='cpanm --mirror-only --mirror https://mirrors.gossamer-threads.com/CPAN/'
function cpanm() {
    #command cpanm $@
    #cpanm-reporter
    command cpanm-parallel $@
}

function cpanmdev() {
    #command cpanm --dev $@
    #cpanm-reporter
    command cpanm-parallel --dev $@
}
function cpanmrec() {
    #command cpanm --dev --recommends $@
    #cpanm-reporter
    command cpanm-parallel --dev --recommends $@
}

# stop using cpanplus
export PERL_AUTOINSTALL_PREFER_CPAN=1

# stop trying to ask me questions and use the defaults already
#export PERL_MB_USE_DEFAULT=1
#export PERL_MM_USE_DEFAULT=1


# install some basic stuff that we need, after 'perlbrew switch'
# this is starting to form the basis of Task::BeLike::ETHER again...
# see also 'bin/newperl'
newperllibs() {
    #curl -L http://cpanmin.us | perl - App::cpanminus
    cpanm \
        App::Ack \
        App::Nopaste \
        App::cpanoutdated \
        App::cpanminus::reporter \
        Module::CoreList \
        Test::CPAN::Meta \
        Test::Pod::Coverage \
        Pod::Coverage::TrustPod \
        Test::CleanNamespaces \
        Test::Most \
        Data::Dumper \
        Archive::Tar::Wrapper \
        LWP::Protocol::https \
        Carp::Always \
        Cpanel::JSON::XS \
        App::mymeta_requires \
        App::cpanminus::reporter \
        Config::Identity::GitHub \
        indirect multidimensional bareword::filehandles

    # this brings in Moose and all its deps too
    cpanm Dist::Zilla::PluginBundle::Author::ETHER \
        Dist::Zilla::App::Command::dumpphases \
        Dist::Zilla::App::Command::podpreview

#    cpanm \
#        Test::LWP::UserAgent \
#        MooseX::Getopt \
#        MooseX::SimpleConfig

    # better would be to just list all the plugins I like to use...
    # or install my pluginbundle directly.
#    pushd ~/git/Test-LWP-UserAgent
#    dzil authordeps --missing | cpanm
#    dzil listdeps --missing | cpanm
#    popd

    # take this out when the stable version exceeds this
    perl -MTest::Simple -wE'system(q{cpanm http://cpan.metacpan.org/authors/id/M/MS/MSCHWERN/Test-Simple-0.98_05.tar.gz}) if Test::Simple->VERSION lt eval q{0.98_05}'
}

# update the main things I care about (run on each perlbrew)
function cpanupdate() {
    perlbrew self-upgrade
    cpanm --self-update
    cpanm \
        App::Ack \
        App::Nopaste \
        App::cpanoutdated \
        Module::CoreList \
        Moose \
        Dist::Zilla \
        Dist::Zilla::PluginBundle::Author::ETHER
}


function metacpan-favorited() {
    curl -s  https://metacpan.org/author/ETHER | perl -nE 'if (m!class="release".*/release/([^"]+)!) { $_ = $1; s/-/::/g; say $_,$/ }'
}
 
function cpanm-metacpan-favorited {
    metacpan-favorited | cpanm
}

# courtesy hobbs, #perl 2013-01-30
# fixed for dupe entries 2022-10-26
errno_list() {
    perl -lE 'for (1..255) { $! = $_; my (@keys) = grep $!{$_}, keys %!; say "$_: ", join(",", @keys), ": $!" if @keys }'
}

jsondump() {
    perl -MJSON -MData::Dumper -wE'$Data::Dumper::Sortkeys = 1; say Dumper(decode_json(qq($ARGV[0])))' "$@"
}

# can take either a dist or module name
newdist() {
    local module=$1
    local dist=`perl -wE"say q{$module} =~ s/::/-/r"`
    pushd ~/git
    dzil new -P Author::ETHER -p default $dist
    pushd _mydists; ln -sf ../$dist; popd
    cd $dist
}

newmodule() {
    dzil add -P Author::ETHER -p default $@
}

minver() {
    perl -MData::Dumper -MPerl::MinimumVersion::Fast -wE'$Data::Dumper::Terse = 1; say "$_: ", Dumper(Perl::MinimumVersion::Fast->new($_)) foreach @ARGV' $@
}

alias dbn='dzil build --not'

perledit() {
    vi `perldoc -lm $@`
}

# run specified command on all @std perlbrew installs
# this doesn't actually work - perlbrew exec seems broken??!
stdperls() {
    # perlbrew exec --with 19.7@std bash -lc "cpanm --reinstall Test::Without::Module"
    perlbrew exec \
        --with $(perlbrew list | perl -w -l -e'print join(",", map { m/([\d.]+.*\@std$)/ ?  $1 : () } <>)') \
        bash -lc "$@"
}

mydists() {
    pushd ~/git/_mydists > /dev/null
    ls -l1
    popd > /dev/null
}

adopteddists() {
    pushd ~/git/_adopteddists > /dev/null
    ls -l1
    popd > /dev/null
}

shippeddists() {
    pushd ~/git/_shippeddists > /dev/null
    ls -l1
    popd > /dev/null
}

comaintdists() {
    pushd ~/git/_comaintdists > /dev/null
    ls -l1
    popd > /dev/null
}

firstcome() {
    local author=${1-ETHER}
    grep ",${author},[fm]" ~/.cpanm/06perms.txt | perl -n -e"s/,${author},[fm]//; s/::/-/g; print"
}

havecomaint() {
    local author=${1-ETHER}
    grep ",${author},c" ~/.cpanm/06perms.txt | perl -n -e"s/,${author},c//; s/::/-/g; print"
}

# <command> | xargs perl -wle'print map { s/-/::/g; $_ . "\n" } @ARGV' | cpanm

# to install arbitrary dists that I paste:
# cat | xargs perl -wle'print map { s/-/::/g; $_ . "\n" } @ARGV' | cpanm

cpanm_mydists() {
    local dists=$(ls -1 ~/git/_mydists | perl -n -e's/-/::/g; print')
    echo cpanmdev --no-report-perl-version $* $dists
    cpanmdev --no-report-perl-version $* $dists
}

cpanm_adopteddists() {
    local dists=$(ls -1 ~/git/_adopteddists | perl -n -e's/-/::/g; print')
    echo cpanmdev --no-report-perl-version $* $dists
    cpanmdev --no-report-perl-version $* $dists
}

cpanm_shippeddists() {
    local dists=$(ls -1 ~/git/_shippeddists | perl -n -e's/-/::/g; print')
    echo cpanmdev --no-report-perl-version $* $dists
    cpanmdev --no-report-perl-version $* $dists
}

cpanm_firstcomedists() {
    local dists=$(firstcome | perl -n -e's/-/::/g; print' | grep -v JSON::Any)
    echo cpanmdev --no-report-perl-version $* $dists
    cpanmdev --no-report-perl-version $* $dists
}

cpanm_myreleases() {
    local dists=$(grep '\bE/ET/ETHER/' ~/.cpanm/02packages.details.txt | cut -d" " -f 1)
    # FIXME: not installing --dev until metacpan is fixed: https://github.com/CPAN-API/cpan-api/issues/483
    echo cpanm --no-report-perl-version $* $dists
    cpanm --no-report-perl-version $* $dists
}

cpanm_core() {
    local dists=$( perl -MModule::CoreList -wE'say foreach grep { !/win32/i } sort keys %{ Module::CoreList->find_version($]) }')
    # FIXME: not installing --dev until metacpan is fixed: https://github.com/CPAN-API/cpan-api/issues/483
    echo cpanm --no-report-perl-version $* $dists
    cpanm --no-report-perl-version $* $dists
}

firstcome_bugs() {
    rt $(firstcome)
}

mydist_bugs() {
    pushd ~/git/_mydists
    rt $(ls -l1)
    popd
}

adopted_bugs() {
    pushd ~/git/_adopteddists
    rt $(ls -l1)
    popd
}

shipped_bugs() {
    pushd ~/git/_shippeddists
    rt $(ls -l1)
    popd
}

# run the command on all major perlbrews, starting at 8.8
almostallperls() {
    for perl in 8.8 8.9 10.0 10.1 12.5 14.4 16.3 18.4 20.3 22.4 24.4 26.3 28.3 30.3 32.1 34.3 36.3 38.4 40.2 41.10 ; do
        perlbrew use ${perl}@std;
        echo; echo using $PERL5LIB
        eval $(printf "%q " "$@")
        #$@
        #command cpanm-reporter
    done
}

allperls () {
    for perl in 8.1 8.5 8.8 8.9 10.0 10.1 12.5 14.4 16.3 18.4 20.3 22.4 24.4 26.3 28.3 30.3 32.1 34.3 36.3 38.4 40.2 41.10 ; do
        perlbrew use ${perl}@std;
        echo; echo using $PERL5LIB
        eval $(printf "%q " "$@")
        #$@
        #command cpanm-reporter
    done
}

modernperls() {
    for perl in 20.3 22.4 24.4 26.3 28.3 30.3 32.1 34.3 36.3 38.4 40.2 41.10 ; do
        perlbrew use ${perl}@std;
        echo; echo using $PERL5LIB
        eval $(printf "%q " "$@")
        ack --nocolor "test FAIL.*5.${perl}" ~/.cpanreporter/reports-sent.db | sort -u
    done
}

everyperl () {
    set -o noglob
    for perl in $(perlbrew list | grep '@std' | grep -v rc | grep -v \*); do
        perlbrew use $perl
        echo; echo using $PERL5LIB
        eval $(printf "%q " "$@")
    done
    set +o noglob
}

mt() {
    test -f Makefile && make clean
    perl Makefile.PL && make test
}

unstale () {
    DZIL_AIRPLANE= dzil stale --all | cpanm
}

# install all modules released by me,
# minus a few oddballs that will screw everything up
cpanm_mymodules() {
        # Moose::Error lost in 2.1200 :/
        # Moose::Exception::* has a few old ones indexed to Moose-1.1205
        # TK tries to install all TK-*
        # Pinto breaks cpanm-reporter
    local dists=$(
        grep ETHER ~/.cpanm/02packages.details.txt \
            | cut -d ' ' -f 1 \
            | grep -v Moose::Error \
            | grep -v Moose::Exception \
            | grep -v ^Task::Kensho$ \
            | grep -v Task::Kensho::Toolchain \
            | grep -v ^Mouse
    )
    echo cpanm --no-report-perl-version --with-develop $dists
    cpanm --no-report-perl-version --with-develop $dists
}

alias db='dzil build --not'
alias dt='dzil test; say tests completed with result $?'
alias dtr='dzil test --release; say tests completed with result $?'

build()
{
    if [ -f Build.PL ]; then
        if [ -f Build ]; then
            echo ./Build realclean
            ./Build realclean
        fi
        echo perl Build.PL\; ./Build
        perl Build.PL; ./Build
    elif [ -f Makefile.PL ]; then
        if [ -f Makefile ]; then
            echo make realclean
            make realclean
        fi
        echo perl Makefile.PL\; make
        perl Makefile.PL; make
    else
        >&2 echo no Build.PL or Makefile.PL
    fi
}

alias pM='perl Makefile.PL'
alias M=make
alias Mc='make clean'
alias Mt='make test'

perm() {
    grep $* ~/.cpanm/06perms.txt
}

# see https://github.com/CPAN-API/cpan-api/wiki/SysAdmin#how-to-reindex-a-missing-module
# pass the fully-qualified dist name as the single argument
# e.g. X/XS/XSAWYERX/MetaCPAN-API-0.33.tar.gz
# e.g. sudo -u metacpan /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan release --latest http://cpan.metacpan.org/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Git.2.039.tar.gz --latest
metacpan_reindex() {
    module=$1
    dist=`grep "^$module\\s" ~/.cpanm/02packages.details.txt | perl -e'print "", (split /\s+/, <>)[2]'`
    echo ''
    echo ssh bm-mc-01.metacpan.org
    echo sudo -u metacpan /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan http://cpan.metacpan.org/authors/id/$dist --latest
}

pt () {
    perltidy -b -bext='/' $*
}

# run all acceptance tests from the bleeding edge
acceptance_tests () {
  tests=(t/zzz-acceptance-draft2020-12.t t/zzz-acceptance-draft2019-09.t t/zzz-acceptance-draft7.t t/zzz-acceptance-draft6.t t/zzz-acceptance-draft4.t)
  if [ -e t/zzz-acceptance-draft2020-12-format.t ]; then
    tests+=(t/zzz-acceptance-draft2020-12-format.t t/zzz-acceptance-draft2019-09-format.t t/zzz-acceptance-draft7-format.t t/zzz-acceptance-draft6-format.t t/zzz-acceptance-draft4-format.t)
  fi

  AUTHOR_TESTING=1 TEST_PREFIXDIR=~/git/JSON-Schema-Test-Suite prove -Ilib ${tests[@]}
}

failed_installs () {
    version=$(perl -wle'print $] =~ s/^5.0(\d{2})0(\d{2})$/"5.".($1+0).".".($2+0)/re')
    ack --nocolor "test FAIL.*$version" ~/.cpanreporter/reports-sent.db | sort -u
}
