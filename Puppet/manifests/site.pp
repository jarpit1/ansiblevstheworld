class { 'apache': }             # use apache module
apache::vhost { 'example.com':  # define vhost resource
  port    => '80',
  docroot => '/var/www/html'
  }


file { "/var/www/html/index.html":
    source => "puppet:///modules/apache/index.html"
}

node default {}
