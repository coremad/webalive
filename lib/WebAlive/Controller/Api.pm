package WebAlive::Controller::Api;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use WebAlive::Model::Webkeeper;
use Mojo::JSON qw(encode_json);

my $keeper = WebAlive::Model::Webkeeper->new;

sub log_list ($self) {
  $self->render(json => $keeper->list);
}

sub add ($self) {
  my $url = $self->param("url") or ($self->render(text => "bad req") and return(0));
  my $resp = "pending";
  $resp = "already exists" if $keeper->add_url($url) == -1;
  $self->render(text => $resp);
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

1;
