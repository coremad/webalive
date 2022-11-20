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
  $r->get('/api/url_count')->to('Api#url_count');
  $r->get('/api/url_list')->to('Api#url_list');
  $r->get('/api/new_urls')->to('Api#new_urls');
  $r->post('/api/add')->to('Api#add');
  $r->post('/api/del')->to('Api#del');
  $r->post('/api/ins_log')->to('Api#ins_log');
  $r->post('/api/ins_headers')->to('Api#ins_headers');

}

sub myconfig {
  return($config);
}
1;
