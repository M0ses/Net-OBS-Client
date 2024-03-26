package Net::OBS::LWP::UserAgent;

use strict;
use warnings;

use base 'LWP::UserAgent';

sub sigauth_credentials {
  my ($self, $creds) = @_;
  die "Credentials a not a HASH Ref!" if $creds && ref($creds) ne 'HASH';
  $self->{sigauth_credentials} = $creds if $creds;
  return $self->{sigauth_credentials};
}

1;
