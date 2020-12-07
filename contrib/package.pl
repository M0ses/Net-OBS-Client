#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Net::OBS::Client::Package;

my $p = Net::OBS::Client::Package->new(
  project    => 'OBS:Server:Unstable',
  name       => 'obs-server',
  repository => 'openSUSE_Factory',
  arch       => 'x86_64',
);

my $s = $p->fetch_status();

print Dumper($s);

my $repo    = 'openSUSE_Factory';
my $arch    = 'x86_64';

print "code: ".$p->code($repo, $arch)."\n";


exit 0;
