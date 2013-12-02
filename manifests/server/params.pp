# Class: nagios::server::params
#
# Parameters for and from the nagios module (server part).
#
# Parameters :
#  none
#
# Sample Usage :
#  include nagios::server::params
#
class nagios::server::params {
    # The easy bunch
    $nagios_service = 'nagios'
    $nagios_user    = 'nagios'

    # plugin_dir needed for the check_nrpe and $USER1$ variable
    $libdir = $::architecture ? {
        'x86_64' => 'lib64',
        'amd64'  => 'lib64',
         default => 'lib',
    }

    $plugin_dir = $::osfamily ? {
        'RedHat' => "/usr/${libdir}/nagios/plugins",
        'Gentoo' => "/usr/${libdir}/nagios/plugins",
        default  => '/usr/libexec/nagios/plugins',
    }

    # This probably needs specialization per OS (needs the final /)
    $cgi_dir  = "/usr/${libdir}/nagios/cgi-bin/"
    $html_dir = "/usr/share/nagios/html/"
}

