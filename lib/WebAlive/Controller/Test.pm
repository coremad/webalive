package WebAlive::Controller::Test;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {
  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'WEB Services Checker');
}

1;
