#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use Net::OBS::Client::Project;

my $p = Net::OBS::Client::Project->new(
  name       => 'OBS:Server:Unstable',
  use_oscrc  => 0
);



my $s = $p->fetch_resultlist(
  package => 'obs-server'
);

print Dumper($s);

exit 0;
