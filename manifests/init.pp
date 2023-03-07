#
# Main class to create autoconfiguring 
# services
#
# @param mailserver
#   the mailserver to connect to
#   defaults to: $::fqdn
#   Remark: if you specify 'hostname' on $incoming/$outgoing
#   Hash, you can overwrite this default for specified service.
# @param documentroot
#   the document root, where to place the file
#   defaults to: '/var/www/html'
# @param apache_config
#   Path to write an apache config snippet. For inclusion in an apache
#   vhost. This file is only needed if you are configure you're vhost
#   not using this module. The vhost generated with this module
#   uses an implicit configuration of these settings.
# @param enable_autodiscover
#   if true, includes ::autoconfigmail::autodiscover
#   defaults to true
# @param enable_autoconfig        = true,
#   if true, includes ::autoconfigmail::autoconfig
#   defaults to true
# @param vhost_type               = 'none',
#   the vhost type to install
#   currently 'apache' and 'none' is supported
#   defaults to 'none'
# @param autoconfig_incoming
#   see ::autoconfigmail::autoconfig for details
#   and example
# @param autoconfig_outgoing
#   see ::autoconfigmail::autoconfig for details
#   and example
# @param autoconfig_documentation
#   see ::autoconfigmail::autoconfig for details
#   and example
# @param autodiscover_protocols
#   see ::autoconfigmail::autodiscover for details
#   and example
#
class autoconfigmail (
  Array            $autoconfig_incoming,
  Array            $autoconfig_outgoing,
  Array            $autodiscover_protocols,
  String           $mailserver               = $facts['networking']['fqdn'],
  String           $documentroot             = '/var/www/html',
  Optional[String] $apache_config            = undef,
  Boolean          $enable_autodiscover      = true,
  Boolean          $enable_autoconfig        = true,
  String           $vhost_type               = 'none',
  Array            $autoconfig_documentation = [],
) {
  if $enable_autodiscover {
    include autoconfigmail::autodiscover
  }

  if $enable_autoconfig {
    include autoconfigmail::autoconfig
  }

  if $apache_config {
    file { $apache_config:
      mode    => '0444',
      content => epp('autoconfigmail/apache.conf.epp', {
          'docroot' => $documentroot,
      }),
    }
  }

  case $vhost_type {
    'apache': { include autoconfigmail::vhost::apache }
    default: {}
  }
}
