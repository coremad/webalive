package WebAlive::Controller::Api;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use WebAlive::Model::Webkeeper;
use JSON;

use Data::Dumper;

my $keeper = WebAlive::Model::Webkeeper->new;

sub list ($self) {
  $self->render(text => encode_json($keeper->list));
}

sub add ($self) {
  # say STDERR Dumper($self->param("url"));
  my $id = $keeper->add_url($self->param("url"));
  $keeper->check_url($id);
  $self->render(text => "ok");
}

sub del ($self) {
  # say STDERR Dumper($self->param("url_id"));
  $keeper->del_url($self->param("id"));
  $self->render(text => "ok");
}

1;
