package WebAlive::Controller::General;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub glanga ($self) {
  $self->render(msg => 'Mojolicious');
}

1;
