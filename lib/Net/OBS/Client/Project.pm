# Copyright (c) 2015 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program (see the file COPYING); if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#
package Net::OBS::Client::Project;

use Moose;
use XML::Structured;

with "Net::OBS::Client::Roles::BuildStatus";
with "Net::OBS::Client::Roles::Client";

has resultlist => (
  is      => 'rw',
  isa     => 'HashRef',
  lazy    => 1,
  default => \&fetch_resultlist
);

# /build/OBS:Server:Unstable/_result
sub fetch_resultlist {
  my ($self, %opts) = @_;

  my $api_path = "/build/" . $self->name . "/_result";
  my @ext;

  while (my ($k,$v) = each %opts) { push @ext, "$k=$v"; }

  $api_path .= "?" . join '&', @ext if @ext;
  my $list = $self->request( GET => $api_path );
  my $data = XMLin( $self->dtd->resultlist, $list );

  $self->resultlist($data);

  return $data;
}

sub code {
  my $self = shift;
  my $ra   = $self->_get_repo_arch(@_);
  return $ra->{code};
}

sub dirty {
  my $self = shift;

  my $ra = $self->_get_repo_arch(@_);

  return ( exists $ra->{dirty} && $ra->{dirty} eq 'true' ) ? 1 : 0;

}

sub _get_repo_arch {
  my $self = shift;
  my ( $repo, $arch ) = @_;

  $self->repository($repo) if $repo;
  $self->arch($arch)       if $arch;

  die "repository and arch needed to get code"
    if ( !$self->repository || !$self->arch );

  foreach my $result ( @{ $self->resultlist->{result} } ) {
    return $result
      if ( $result->{repository} eq $self->repository
      && $result->{arch} eq $self->arch );
  }

  die "combination of repository and arch not found";
}

1;

