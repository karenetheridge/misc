# to alter ExtUtils::MakeMaker options (e.g. compile options used in cpan):
# export PERL_MM_OPT="INC=-I/opt/local/include LIBS=-L/opt/local/lib"

# export PATH=/usr/local/ActivePerl-5.8/bin:$PATH

export HARNESS_OPTIONS=j5:c

# used by ExtUtils::Install 1.68+
export PERL_INSTALL_QUIET=1

export NO_NETWORK_TESTING=1

# ensure version for 'dzil run' subshells does not affect subsequent builds
unset V

# don't do this everywhere... just remember how to do it when we need it.
# PERL_MM_OPT=NORECURS=1

# see App::Nopaste::Command
export NOPASTE_SERVICES="Shadowcat Gist"


# equivalent to perldoc -l <module>
perlwhere() {
    perl -wle'eval "require $ARGV[0]" or die; ($mod = $ARGV[0]) =~ s|::|/|g; print $INC{"${mod}.pm"}' $1
}

perlversion() {
    perl -m$1 -wle'print $ARGV[0]->VERSION' $1
}

# given a class name, dumps its symbol table
dumpsymbols() {
    perl -Ilib -MData::Dumper -MModule::Runtime=use_module -wle'
        local $Data::Dumper::Terse = 1;
        local $Data::Dumper::Sortkeys = 1;
        foreach my $className (@ARGV)
        {
            use_module($className);
            print "symbols in $className:";
            no strict "refs";
            print Dumper(\%{"main::${className}::"});
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
    perl -wle'
        my $dist = shift @ARGV;
        $dist =~ s/::/-/g;
        $dist =~ s/moose/Moose/;
        $dist =~ s/oosex/ooseX/i;
        $dist =~ s/-([a-z])/"-". uc($1)/e;
        print "git://git.moose.perl.org/", $dist, ".git"' $1
}



releases() {
    egrep '(CPAN Upload|Day changed)' irclogs/IRCnet*/#moose.log | less
}

# if App::cpanminus::reporter is installed, we send reports automatically
#alias cpanm='cpanm --mirror-only --mirror http://mirrors.gossamer-threads.com/CPAN/'
function cpanm() {
    command cpanm --mirror-only --mirror http://mirrors.gossamer-threads.com/CPAN/ $@
    cpanm-reporter
}

function cpanmdev() {
    command cpanm --with-recommends --dev $@
    cpanm-reporter
}

export NOPASTE_SERVICES='Shadowcat Gist Pastie Snitch'

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
    perl -MTest::Simple -wle'system(q{cpanm http://cpan.metacpan.org/authors/id/M/MS/MSCHWERN/Test-Simple-0.98_05.tar.gz}) if Test::Simple->VERSION lt eval q{0.98_05}'
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
    curl -s  https://metacpan.org/author/ETHER | perl -ne 'if (m!class="release".*/release/([^"]+)!) { $_ = $1; s/-/::/g; print $_,$/ }'
}
 
function cpanm-metacpan-favorited {
    metacpan-favorited | cpanm
}

# courtesy hobbs, #perl 2013-01-30
errno_list() {
    perl -le 'for (1..255) { $! = $_; my ($key) = grep $!{$_}, keys %!; print "$_: $key: $!" if defined $key }'
}

json() {
    perl -MJSON -MData::Dumper -wle'$Data::Dumper::Sortkeys = 1; print Dumper(decode_json(qq($ARGV[0])))' "$@"
}

# can take either a dist or module name
newdist() {
    local module=$1
    local dist=`perl -we"print q{$module} =~ s/::/-/r"`
    pushd ~/git
    dzil new -P Author::ETHER -p default $dist
    pushd _mydists; ln -sf ../$dist; popd
    cd $dist
}

newmodule() {
    dzil add -P Author::ETHER -p default $@
}

minver() {
    perl -MData::Dumper -MPerl::MinimumVersion::Fast -wle'$Data::Dumper::Terse = 1; print "$_: ", Dumper(Perl::MinimumVersion::Fast->new($_)) foreach @ARGV' $@
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
    cpanm $(perl -wle'print map { s/-/::/g; $_ . "\n" } @ARGV' $(ls -1 ~/git/_mydists))
}

firstcome() {
    gzcat ~/.cpanm/06perms.txt.gz | ack ',ETHER,[fm]' | perl -n -e's/,ETHER,[fm]//; s/::/-/g; print'
}

disapprove() {
    perl -CS -wle'print v3232.95.3232'  # 0x0CA0 0x5F 0x0CA0
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

snowman () {
    perl -CO -le'print v9731'   # 0x2603
}

heart () {
    perl -CO -le'print v9825'   # 0x2661
}

# run the command on all major perlbrews
allperls () {
    for perl in 8.9 10.1 12.5 14.4 16.3 18.4 20.2 21.10; do
        perlbrew use ${perl}@std;
        echo; echo using $PERL5LIB
        eval $(printf "%q " "$@")
        #$@
        #command cpanm-reporter
    done
}

unstale () {
    dzil stale --all | cpanm
}

# install all modules released by me,
# minus a few oddballs that will screw everything up
mymodules() {
        # Moose::Error lost in 2.1200 :/
        # Moose::Exception::* has a few old ones indexed to Moose-1.1205
        # TK tries to install all TK-*
        # Pinto breaks cpanm-reporter
    grep ETHER ~/.cpanm/02packages.details.txt \
        | cut -d ' ' -f 1 \
        | grep -v Moose::Error \
        | grep -v Moose::Exception \
        | grep -v ^Task::Kensho$ \
        | grep -v Task::Kensho::Toolchain \
        | grep -v ^Mouse \
        | cpanm --no-report-perl-version
}

alias dtr='dzil test --release'

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

