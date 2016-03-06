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
package Net::OBS::Client::Package;

use Moose;
use XML::Structured;

# define roles
with "Net::OBS::Client::Roles::BuildStatus";
with "Net::OBS::Client::Roles::Client";

has ['+project','+repository','+arch'] => ( required => 1 );

has details => (
  is => 'rw',
  isa => 'Str'
);

has _status => (
  is => 'rw',
  isa => 'HashRef',
  lazy => 1,
  default => \&fetch_status
);

sub fetch_status {
  my $self = shift;

  my $api_path = join('/',"/build",$self->project,$self->repository,$self->arch,$self->name,"_status");

  my $list = $self->request(GET=>$api_path);

  my $data = XMLin($self->dtd->buildstatus,$list);

  return $data;
}

sub code {
  return $_[0]->_status->{code};
}


__PACKAGE__->meta->make_immutable();

1; 

