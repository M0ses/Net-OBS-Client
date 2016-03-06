package Net::OBS::Client::Roles::Client;

use Moose::Role;

use LWP::UserAgent;
use XML::Structured;
use Config::Tiny;
use feature 'say';
use HTTP::Request;
use URI::URL;
use Path::Class qw/file/;
use HTTP::Cookies;

=head1 NAME

Net::OBS::Client - The great new Net::OBS::Client!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::OBS::Client;

    my $foo = Net::OBS::Client->new();
    ...

=head1 ATTRIBUTES

=head2 apiurl -

=head2 useragent -

=head2 oscrc -


=head1 METHODS

=head2 handle_get

=cut

has use_oscrc => (
  is      =>    'rw',
  isa     =>    'Bool'
);

has apiurl => (
  is      =>    'rw',
  isa     =>    'Str',
  lazy    =>    1,
  default =>    sub {
    my $self = shift;
    return $self->oscrc->{general}->{apiurl} if ($self->use_oscrc);
    return 'https://api.opensuse.org';
  }
);

has user => (
  is      =>    'rw',
  isa     =>    'Str',
  lazy    =>    1,
  default =>    sub {
    my $self = shift;
    return $self->oscrc->{$self->apiurl}->{user} if ($self->use_oscrc);
    return ''
  }
);

has pass => (
  is      =>    'rw',
  isa     =>    'Str',
  lazy    =>    1,
  default =>    sub {
    my $self = shift;
    return $self->oscrc->{$self->apiurl}->{pass} if ($self->use_oscrc);
    return ''
  }
);


has user_agent => (
  is      =>    'rw',
  isa     =>    'Object',
  lazy    =>    1,
  default => sub {
    my $self = shift;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;

    return $ua
  }
  
);

has oscrc => ( 
  is      =>    'rw',
  isa     =>    'Object',
  lazy    =>    1,
  default =>    sub {
    my $cf =  Config::Tiny->read($ENV{HOME}."/.oscrc");
    die "Cannot open .oscrc" if ! $cf;
    return $cf;
  }

);

sub debug {
  if ( $ENV{NET_OBS_CLIENT_DEBUG} ){
    foreach my $line (@_) {
      say $line
    }
  }
}

sub request {
  my $self      = shift;
  my $method    = shift;
  my $api_path  = shift;

  my $ua = $self->user_agent();
  my $url = $self->apiurl . $api_path;

  debug(" $method: $url");

  my $req = HTTP::Request->new($method => $url);
  $req->authorization_basic($self->user,$self->pass);

  my $response = $ua->request($req);

  if ($response->is_success) {
    return $response->decoded_content;  # or whatever
  } else {
      die $response->status_line;
  }
}

1; # End of Net::OBS::Client
