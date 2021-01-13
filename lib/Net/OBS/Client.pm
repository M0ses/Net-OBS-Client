package Net::OBS::Client;

use Moose;
use Net::OBS::Client::Project;
use Net::OBS::Client::Package;
use Net::OBS::Client::BuildResults;


with "Net::OBS::Client::Roles::Client";

our $VERSION = '0.0.6';

sub project {
  my $self = shift;
  return Net::OBS::Client::Project->new(
    apiurl     => $self->apiurl,
    use_oscrc  => $self->use_oscrc,
    @_
  );
}

sub package {
  my $self = shift;
  return Net::OBS::Client::Package->new(
    apiurl     => $self->apiurl,
    use_oscrc  => $self->use_oscrc,
    @_
  );
}

sub buildresults {
  my $self = shift;
  return Net::OBS::Client::BuildResults->new(
    apiurl     => $self->apiurl,
    use_oscrc  => $self->use_oscrc,
    @_
  );
}

1;    # End of Net::OBS::Client

__END__

=head1 NAME

Net::OBS::Client - simple OBS API calls

=head1 SYNOPSIS

  #
  use Net::OBS::Client;
  my $c = Net::OBS::Client->new(
    apiurl     => $apiurl,
    use_oscrc  => 0,
  );

  my $prj = $c->project(
    name       => $project,
  );

  my $pkg = $c->package(
    project    => 'OBS:Server:Unstable',
    name       => 'obs-server',
    repository => 'openSUSE_Factory',
    arch       => 'x86_64',
  );

  my $res = $c->buildresults(
    project    => $project,
    package    => $package,
    repository => $repo,
    arch       => $arch,
  );

  #
  use Net::OBS::Client::Project;
  use Net::OBS::Client::Package;

  my $prj = Net::OBS::Client::Project->new(
    apiurl     => $apiurl,
    name       => $project,
    use_oscrc  => 0,
  );

  my $s = $prj->fetch_resultlist(package => $package);

  my $pkg = Net::OBS::Client::Package->new(
    project    => 'OBS:Server:Unstable',
    name       => 'obs-server',
    repository => 'openSUSE_Factory',
    arch       => 'x86_64',
    use_oscrc  => 0,
    apiurl     => 'https://api.opensuse.org/public'
  );

  my $state = $pkg->fetch_status();


=head1 DESCRIPTION

Net::OBS::Client aims to simplify usage of OBS (https://openbuildservice.org) API calls in perl.


=head1 AUTHOR

Frank Schreiner, C<< <frank at samaxi.de> >>

=head1 SEE ALSO

L<Net::OBS::Client::Package>, L<Net::OBS::Client::Project>, L<Net::OBS::Client::BuildResults>

You can find some examples in the L<contrib/> directory


=head1 COPYRIGHT

Copyright 2016 Frank Schreiner <frank@samaxi.de>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

