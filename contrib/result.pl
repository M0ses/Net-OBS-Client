#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use Net::OBS::Client::Package;

my $p = Net::OBS::Client::Package->new(
  project    => 'OBS:Server:Unstable',
  name       => 'obs-server',
  repository => 'openSUSE_Factory',
  arch       => 'x86_64',
  use_oscrc  => 0,
  apiurl     => 'https://api.opensuse.org/public'
);

my $s = $p->fetch_status();

print Dumper($s);

exit 0;
