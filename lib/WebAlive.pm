package WebAlive;
use Mojo::Base 'Mojolicious', -signatures;

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
  $r->get('/')->to('General#glanga');
  $r->get('/api/list')->to('Api#log_list');
  $r->get('/api/new_urls_count')->to('Api#new_urls_count');
  $r->post('/api/add')->to('Api#add');
  $r->post('/api/del')->to('Api#del');

}

1;
