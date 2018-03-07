#
# Main class
#
# Parameters:
#  $mailserver
#    the mailserver to connect to
#    defaults to: $::fqdn
#    Remark: if you specify 'hostname' on $incoming/$outgoing
#    Hash, you can overwrite this default for specified service.
#
#  $documentroot
#    the document root, where to place the file
#    defaults to: '/var/www/html'
#
#  $enable_autodiscover
#    if true, includes ::autoconfigmail::autodiscover
#    defaults to true
#  $enable_autoconfig        = true,
#    if true, includes ::autoconfigmail::autoconfig
#    defaults to true
#  $vhost_type               = 'none',
#    the vhost type to install
#    currently 'apache' and 'none' is supported
#    defaults to 'none'
# $autoconfig_incoming
#    see ::autoconfigmail::autoconfig for details
#    and example
# $autoconfig_outgoing
#    see ::autoconfigmail::autoconfig for details
#    and example
# $autoconfig_documentation
#    see ::autoconfigmail::autoconfig for details
#    and example
# $autodiscover_protocols
#    see ::autoconfigmail::autodiscover for details
#    and example
#
class autoconfigmail (
  String  $mailserver               = $::fqdn,
  String  $documentroot             = '/var/www/html',
  Boolean $enable_autodiscover      = true,
  Boolean $enable_autoconfig        = true,
  String  $vhost_type               = 'none',
  Array   $autoconfig_incoming      = $autoconfigmail::params::autoconfig_incoming_default,
  Array   $autoconfig_outgoing      = $autoconfigmail::params::autoconfig_outgoing_default,
  Array   $autoconfig_documentation = $autoconfigmail::params::autoconfig_documentation_default,
  Array   $autodiscover_protocols   = $autoconfigmail::params::autodiscover_protocols_default,
) inherits autoconfigmail::params {

  if $enable_autodiscover {
    include ::autoconfigmail::autodiscover
  }

  if $enable_autoconfig {
    include ::autoconfigmail::autoconfig
  }

  case $vhost_type {
    'apache': { include ::autoconfigmail::vhost::apache }
    default: {}
  }
}
