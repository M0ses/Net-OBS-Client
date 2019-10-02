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

has use_oscrc => (
  is      =>    'rw',
  isa     =>    'Bool'
);

has apiurl => (
  is      =>    'rw',
  isa     =>    'Str',
  lazy    =>    1,
  default =>    sub {
    my $self    = shift;
    my $default = 'https://api.opensuse.org/public';
    return $default if !$self->use_oscrc;
    return $self->oscrc->{general}->{apiurl} if ($self->use_oscrc);
    return $default;
  }
);

has user => (
  is      =>    'rw',
  isa     =>    'Str|Undef',
  lazy    =>    1,
  default =>    sub {
    my $self = shift;
    return $self->oscrc->{$self->apiurl}->{user} if ($self->use_oscrc);
    return ''
  }
);

has pass => (
  is      =>    'rw',
  isa     =>    'Str|Undef',
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
    if ($ENV{NET_OBS_CLIENT_DEBUG}) {
      require LWP::ConsoleLogger::Easy;
      LWP::ConsoleLogger::Easy->import('debug_ua');
      debug_ua($ua);
    }
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
    my $rc;
    if ( -f "$ENV{HOME}/.oscrc" ) {
      $rc = "$ENV{HOME}/.oscrc";
    } elsif (-f "$ENV{HOME}/.config/osc/oscrc") {
      $rc = "$ENV{HOME}/.config/osc/oscrc";
    } else {
      die "No oscrc found";
    }
    my $cf =  Config::Tiny->read($rc);
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
  if ( $self->user ) {
    $req->authorization_basic($self->user,$self->pass);
  }

  my $response = $ua->request($req);

  if ($response->is_success) {
    return $response->decoded_content;  # or whatever
  } else {
      die $response->status_line . " while $method Request on $url\n";
  }
}

1; # End of Net::OBS::Client
