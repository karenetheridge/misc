#!/usr/bin/env perl

use v5.34;  # what macports gives us
use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use File::Spec;
use File::Copy;

# - can run from anywhere - use hardcoded paths.
# - uses core modules only.
# - links from generic/* to ~/*, via $HOST/*.

my $host = shift || die 'Usage: new-machine.pl <hostname>';
my $install = glob($ENV{HOME}.'/git/misc/install');

# basenames of files to copy, not link
my @copy = qw(
  .gitattributes
);

if (not -d "$install/$host") {
  say "mkdir $install/$host";
  mkdir "$install/$host";
}

make_host_link($install, $host);

sub make_host_link ($install, $host, $target = '', $level = 0) {
  say "make_host_link('$install', '$host', '$target', $level)";
  my $host_file = "$install/$host/$target";   # link or directory

  if (-l $host_file) {
    say "link already exists: $host_file";
    make_origin_link($install, $host, $target);
  }
  # recurse, if generic is a directory and host directory already exists
  elsif (-d "$install/$host/$target") {
    say "$install/$host/$target is a directory";
    my @children = map +((reverse File::Spec->splitpath($_))[0]),
      grep $_ !~ m{/\.{1,2}$},
      glob("$install/generic/$target/* $install/generic/$target/.*");
    make_host_link($install, $host, (length $target ? "$target/$_" : $_), $level+1) foreach @children;
  }
  else {
    my $source = "$install/$host/$target";
    my ($basename) = (reverse File::Spec->splitpath($target))[0];
    if (grep $basename eq $_, @copy) {
      my $original = "$install/generic/$target";
      say "copying $original to $source ";
      copy($original, $source) or die "copy $source <- $original failed: $!";
    } else {
      my $dest = join('/',(('..')x$level), 'generic', $target);
      if (not -e $source) {
        say "symlink $dest, $source";
        symlink($dest, $source) or die "symlink $dest <- $source failed: $!";
      }
    }

    make_origin_link($install, $host, $target);
  }
}

# this is not recursive (is it needed?) and uses absolute paths
sub make_origin_link ($install, $host, $target) {
  say "make_origin_link('$install', '$host', '$target')";
  my ($basename) = (reverse File::Spec->splitpath($target))[0];
  return if $basename eq '.gitignore';

  my $source = "$ENV{HOME}/$target";
  my $dest = "$install/$host/$target";
  if (-l $source) {
    say "link already exists: $source";
    return;
  }
  elsif (-d $source) {
    say "directory already exists: $source";
    return;
  }
  say "symlink $dest, $source";
  symlink($dest, $source) or die "symlink $dest <- $source failed: $!";
}

say "Files under $install/$host created! Look them over, delete as desired, then git add.";
