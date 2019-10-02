#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Net::OBS::Client::Project;

$::ENV{NET_OBS_DEBUG} = 1;

my $apiurl  = 'https://api.opensuse.org/public';
my $project = 'OBS:Server:Unstable';
my $package = 'obs-server';

my $p = Net::OBS::Client::Project->new(
  apiurl     => $apiurl,
  name       => $project,
  use_oscrc  => 0,
);

my $s = $p->fetch_resultlist(package => $package);

print Dumper($s);

exit 0;
