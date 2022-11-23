package WebAlive::Controller::Api;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::UserAgent;
use WebAlive::Model::Webkeeper;
use Mojo::JSON qw(encode_json);
use WebAlive;

my $keeper = WebAlive::Model::Webkeeper->new;
my $config;

sub log_list ($self) {
  $self->render(json => $keeper->list);
}

sub check_url {
  my ($self, $row) = @_;
  my $ua  = Mojo::UserAgent->new;
  my $res;
  eval {$res = $ua->get($row->{url})->result;};
  my $log_id = $keeper->ins_log($row->{id}, $res->{code});
  return (0) unless $res and exists $res->{code} and exists $res->headers->{headers};
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
}

sub del ($self) {
  my $resp = "ok";
  $keeper->del_url($self->param("id")) or $resp = "error";
  $self->render(text => $resp);
}

sub url_list($self) {
  $self->render(json => $keeper->url_list);
}

sub url_count($self) {
  $self->render(text => $keeper->url_count);
}

sub new_urls($self) {
  $self->render(json => $keeper->get_new_urls);
}

sub new_urls_count($self) {
  $self->render(text => $keeper->new_urls_count);
}

sub ins_log($self) {
  my $row = $self->{tx}->{req}->json;
  my $log_id = $keeper->ins_log($row->{id}, $row->{code});
  $self->render(text => $log_id);
}

sub ins_headers($self) {
  my $row = $self->{tx}->{req}->json;
  $keeper->ins_header($row->{log_id}, $row->{header_name}, $row->{headers});
  $self->render(text => 'ok');
}

1;
