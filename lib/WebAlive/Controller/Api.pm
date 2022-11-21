package WebAlive::Controller::Api;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::UserAgent;
use WebAlive::Model::Webkeeper;
use WebAlive;

use JSON;

my $keeper = WebAlive::Model::Webkeeper->new;
my $config;

sub list ($self) {
  $self->render(text => encode_json($keeper->list));
}



sub check_url {
  my ($self, $row) = @_;
  my $ua  = Mojo::UserAgent->new;
  my $res;
  eval {$res = $ua->get($row->{url})->result;};
  my $log_id = $keeper->ins_log($row->{id}, $res->{code});
  return (0) unless exists $res->{code} and exists $res->headers->{headers};
  $config = WebAlive::myconfig;
  my $headers = $res->headers->{headers};
  my $header_count = $config->{max_headers};
  foreach my $header_name (keys %{$headers}) {
    $keeper->ins_header($log_id, $header_name, encode_json($headers->{$header_name}));
    --$header_count or last();
  }
}

sub add ($self) {
  my $url = $self->param("url") or ($self->render(text => "bad req") and return(0));
  my $id = $keeper->add_url($url);
  if ($id == -1) {
    $self->render(text => "already exists");
    return(0);
  }
  $self->check_url({id => $id, url => $url});
  $self->render(text => "ok");
  return(1);
  # $self->render(text => "WTF?!");
}

# sub add ($self) {
#   my $url = $self->param("url") or ($self->render(text => "bad req") and return(0));
#   my $id = $keeper->add_url($url);
#   if ($id == -1) {
#     $self->render(text => "already exists");
#     return(0);
#   }
#   my $pid_file = WebAlive::myconfig->{pid_file};
#   unless (-f $pid_file) {
#     $self->render(text => "cant find daemon");
#     return(0);
#   }
#   my $pf;
#   if(open ($pf, '<', $pid_file) and my $pid = <$pf>) {
#     close $pf;
#     $self->render(text => "ok");
#     kill USR1 => $pid;
#     return(1);
#   }
#   $self->render(text => "WTF?!");
# }

sub del ($self) {
  $keeper->del_url($self->param("id"));
  $self->render(text => "ok");
}

sub url_list($self) {
  my @urls = $keeper->url_list;
  $self->render(text => encode_json(\@urls));
}
sub url_count($self) {
  $self->render(text => $keeper->url_count);
}



sub new_urls($self) {
  my @urls = $keeper->get_new_urls;
  $self->render(text => encode_json(\@urls));
}

sub ins_log($self) {
  my $req = $self->{tx}->{req}->{content}->{asset}->{content};
  my $row = decode_json($req);
  my $log_id = $keeper->ins_log($row->{id}, $row->{code});

  $self->render(text => encode_json({ log_id => $log_id }));
}


sub ins_headers($self) {
  my $req = $self->{tx}->{req}->{content}->{asset}->{content};
  my $row = decode_json($req);
  $keeper->ins_header($row->{log_id}, $row->{header_name}, $row->{headers});
  $self->render(text => 'ok');
}

1;
