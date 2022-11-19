package WebAlive;
use Mojo::Base 'Mojolicious', -signatures;

use Data::Dumper;

my $config;
# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Test#welcome');
  $r->get('/api/list')->to('Api#list');
  $r->post('/api/add')->to('Api#add');
  $r->post('/api/del')->to('Api#del');

}

sub myconfig {
  return($config);
}
1;
