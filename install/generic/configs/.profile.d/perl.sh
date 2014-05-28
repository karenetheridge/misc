# to alter ExtUtils::MakeMaker options (e.g. compile options used in cpan):
# export PERL_MM_OPT="INC=-I/opt/local/include LIBS=-L/opt/local/lib"

# export PATH=/usr/local/ActivePerl-5.8/bin:$PATH

export HARNESS_OPTIONS=j9

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
            eval "require $className";
            die "Cannot load $className: $@" if $@;
            no strict "refs";
            print Dumper(\%{"main::${className}::"});
        }
' $*
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
        print "gitmo\@git.moose.perl.org:", $dist, ".git"' $1
}


# see App::Nopaste::Command
# this may need to be defined in order to do nopaste --chan <foo>
#export NOPASTE_SERVICES='Shadowcat Pastie'

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
    dzil new -P Author::ETHER -p github $dist
    pushd mydists; ln -sf ../$dist; popd
    cd $dist
}

newmodule() {
    dzil add -P Author::ETHER -p github $*
}

minver() {
    perl -MData::Dumper -MPerl::MinimumVersion::Fast -wle'$Data::Dumper::Terse = 1; print "$_: ", Dumper(Perl::MinimumVersion::Fast->new($_)) foreach @ARGV' $*
}

alias dbn='dzil build --not'

perledit() {
    vi `perldoc -lm $*`
}

# run specified command on all @std perlbrew installs
stdperls() {
    perlbrew exec --with $(perlbrew list | perl -w -l -e'print join(",", map { m/([\d.]+.*\@std$)/ ?  $1 : () } <>)') $*
}
