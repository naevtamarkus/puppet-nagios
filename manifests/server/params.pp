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
    
    $server_packages = [
        'nagios',
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-http',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
        'nagios-plugins-udp',
    ]
    
        # nagios.cfg
    $cfg_file = [
        # Original files - only reuse the templates as-is
#        '/etc/nagios/objects/commands.cfg',
#        '/etc/nagios/objects/contacts.cfg',
#        '/etc/nagios/objects/timeperiods.cfg',
        '/etc/nagios/objects/templates.cfg',   #TODO why is this file NOT managed by the module?
        # Where puppet managed types are
        '/etc/nagios/nagios_command.cfg',
        '/etc/nagios/nagios_contact.cfg',
        '/etc/nagios/nagios_contactgroup.cfg',
        '/etc/nagios/nagios_host.cfg',
        '/etc/nagios/nagios_hostdependency.cfg',
        '/etc/nagios/nagios_hostgroup.cfg',
        '/etc/nagios/nagios_service.cfg',
        '/etc/nagios/nagios_servicegroup.cfg',
        '/etc/nagios/nagios_timeperiod.cfg',
    ]
    
}

