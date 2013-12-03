class nagios::server::external_apache () {
    # Configure apache with apache_httpd module only if requested
    if $nagios::server::apache_httpd {
        require apache_httpd::install
        require apache_httpd::service::ssl
        apache_httpd { 'prefork':
            ssl       => $nagios::server::apache_httpd_ssl,
            modules   => $nagios::server::apache_httpd_modules,
            keepalive => 'On',
        }

        file { '/etc/httpd/conf.d/nagios.conf':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => $nagios::server::apache_httpd_conf_content,
            notify  => Service['httpd'],
            require => Package['nagios'],
        }

        if $nagios::server::apache_httpd_htpasswd_source != false {
            file { '/etc/nagios/.htpasswd':
                owner   => 'root',
                group   => 'apache',
                mode    => '0640',
                source  => $nagios::server::apache_httpd_htpasswd_source,
                require => Package['nagios'],
            }
        }

        if $nagios::server::php {
            include php::mod_php5
            php::ini { '/etc/php.ini': }
            if $nagios::server::php_apc { php::module { 'pecl-apc': } }
        }
    }

    # Configure apache with puppetlabs-apache module only if requested
    if $nagios::server::puppetlabs_apache {
        #class {'apache': default_vhost => false, default_ssl_vhost => false}
        include apache
        include apache::mod::php
        include apache::mod::ssl
        apache::vhost { 'nagios':
            port           => 443,
            ssl            => true,
            docroot        => $nagios::server::params::html_dir,
            # Avoided scriptaliases because they will go AFTER the aliases and therefore not work
            aliases        => [
                { alias => '/nagios/cgi-bin/', path => $nagios::server::params::cgi_dir }, 
                { alias => '/nagios/', path => $nagios::server::params::html_dir }
            ],
            directories    => [
                { path             => $nagios::server::params::cgi_dir,
                  'addhandlers'    => [{ handler => 'cgi-script', extensions => ['.cgi']}],
                  'options'        => 'ExecCGI',
                  'order'          => 'Deny,Allow',
                  'deny'           => 'from all',
                  'allow'          => "from ${nagios::server::apache_allowed_from}",
                  'auth_type'      => 'Basic',
                  'auth_user_file' => '/etc/nagios/.htpasswd',
                  'auth_name'      => 'Nagios',
                  'auth_require'   => 'valid-user',
                } , {
                  path             => $nagios::server::params::html_dir,
                  'options'        => 'FollowSymlinks',
                  'order'          => 'Deny,Allow',
                  'deny'           => 'from all',
                  'allow'          => "from ${nagios::server::apache_allowed_from}",
                  'auth_type'      => 'Basic',
                  'auth_user_file' => '/etc/nagios/.htpasswd',
                  'auth_name'      => 'Nagios',
                  'auth_require'   => 'valid-user',
                }
            ], # end directories
        } # end vhost
    }
}