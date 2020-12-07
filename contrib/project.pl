#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Net::OBS::Client::Project;

$::ENV{NET_OBS_DEBUG} = 1;

my $project = 'OBS:Server:Unstable';
my $package = 'obs-server';
my $repo    = 'openSUSE_Factory';
my $arch    = 'x86_64';

my $p = Net::OBS::Client::Project->new(
  name       => $project,
  use_oscrc  => 0,
);

my $s = $p->fetch_resultlist(package => $package);

print Dumper($s);

print "code: ".$p->code($repo, $arch)."\n";
print "dirty: ".$p->dirty($repo, $arch)."\n";

exit 0;
