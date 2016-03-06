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
package Net::OBS::Client::BuildResults;

use Moose;
use Net::OBS::Client;
use Net::OBS::Client::DTD;
use XML::Structured;
use Data::Dumper;

with "Net::OBS::Client::Roles::Client";

has project => (
  is  => 'rw',
  isa => 'Str',
);

has repository => (
  is  => 'rw',
  isa => 'Str',
);

has arch => (
  is  => 'rw',
  isa => 'Str',
);

has package => (
  is  => 'rw',
  isa => 'Str',
);

sub binarylist {
  my $self = shift;

  my $api_path = "/build/"
    . join(
        "/",
        $self->project,
        $self->repository,
        $self->arch,
        $self->package
      );

  my $binarylist = $self->request( GET => $api_path );

  my $dtd = Net::OBS::Client::DTD->new()->binarylist();

  return XMLin( $dtd, $binarylist )->{binary};

}

sub fileinfo {
  my $self   = shift;
  my $binary = shift;

  # /build/OBS:Server:Unstable/images/x86_64/OBS-Appliance-qcow2/obs-server.x86_64-2.5.51-Build6.4.qcow2?view=fileinfo
  #
  my $api_path = "/build/"
    . join(
        "/",
          $self->project,
          $self->repository,
          $self->arch,
          $self->package,
          $binary
      );
  $api_path .= '?view=fileinfo';

  my $binarylist = $self->request( GET => $api_path );

  my $dtd = Net::OBS::Client::DTD->new()->fileinfo();

  return XMLin( $dtd, $binarylist );

}

1;

