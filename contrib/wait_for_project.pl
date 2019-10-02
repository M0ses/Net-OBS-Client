#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Net::OBS::Client::Project;

my $apiurl     = "https://obs-server/public";
my $project    = 'BaseContainer';
my $package    = 'openSUSE-Leap-Container-Base';
my $repository = 'images';
my $arch       = 'x86_64';

my $p = Net::OBS::Client::Project->new(
  apiurl     => $apiurl,
  name       => $project,
  repository => $repository,
  arch       => $arch,
  # use_oscrc  => 0,
);

$p->user_agent->timeout(0);

my $s= {result=>[{code=>''}]};

while ($s->{result}->[0]->{code} ne 'published') {
  my $d = { 
    package => $package,
    multibuild => 1,
    locallink => 1,
  };
  $d->{oldstate} = $s->{state} if $s->{state};
  $s = $p->fetch_resultlist(%$d);
  print Dumper($p->dirty);
  print Dumper($p->code);
  print Dumper($s);
  sleep 1;
}


exit 0;
