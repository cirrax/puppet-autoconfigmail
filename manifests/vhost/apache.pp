#
# internal class that installs an apache vhost
# to serve xml files.
#
# Parameters:
#   $servername
#     main servername defaults to $autoconfigmail::mailserver
#   $serveraliases
#     serveraliases, defaults to []
#   $enable_autoconfig_alias
#     if true (default) adds a serveralias 'autoconfig.*'
#     for autoconfig.
#   $apache_vhost_defaults
#     other parameters to ::apache::vhost
#     defaults to {}
#   $documentroot
#     the document root of the webwerver
#     defaults to: $autoconfigmail::documentroot
#   $ssl
#     If true, use ssl (defaults to false)
#     If true, you also need to set cert, key and chain.
#   $ssl_cert
#     ssl cert to use 
#   $ssl_key
#     ssl key to use
#   $ssl_chain
#     ssl chain to use
#   $vhost_add
#     Hash to add additional parameters to ::apache::vhost creation
#
#     Example in hiera to add an additional include file:
#       autoconfigmail::vhost::apache::vhost_add:
#         additional_includes:
#             - '/etc/letsencrypt/apache.conf'
#
#   $create_resources
#     a Hash of Hashes to create additional resources eg. to 
#     retrieve a certificate.
#     Defaults to {} (do not create any additional resources)
#     Example (hiera):
#
#     autoconfigmail::vhost::apache::create_resources:
#       sslcert::get_cert:
#         get_my_postfix_cert:
#           private_key_path: '/etc/postfixadmin/ssl/key.pem'
#           cert_path: '/etc/postfixadmin/ssl/cert.pem'
#    
#     Will result in  executing:
#
#     sslcert::get_cert{'get_my_postfix_cert':
#       private_key_path => '/etc/postfixadmin/ssl/key.pem'
#       cert_path        => '/etc/postfixadmin/ssl/cert.pem'
#     }
# 
class autoconfigmail::vhost::apache (
  String  $servername              = $autoconfigmail::mailserver,
  Array   $serveraliases           = [],
  Boolean $enable_autoconfig_alias = true,
  Hash    $apache_vhost_defaults   = {},
  String  $documentroot            = $autoconfigmail::documentroot,
  Boolean $ssl                     = false,
  String  $ssl_cert                = '',
  String  $ssl_key                 = '',
  String  $ssl_chain               = '',
  Hash    $vhost_add               = {},
  Hash    $create_resources        = {},
) inherits autoconfigmail {

  include ::apache
  include ::apache::mod::php

  if $enable_autoconfig_alias {
    $_serveraliases = union($serveraliases, ['autoconfig.*'])
  } else {
    $_serveraliases = $serveraliases
  }

  if $ssl_cert != '' {
    $vhosts = {
      $servername => {
        'serveraliases' => $_serveraliases,
        'port'          => '80',
      },
      "${servername}_SSL" => {
        'servername'      => $servername,
        'serveraliases'   => $serveraliases, # autoconfig * alias is not suitable for a cert !
        'port'            => '443',
        'ssl'             => $ssl,
        'ssl_cert'        => $ssl_cert,
        'ssl_key'         => $ssl_key,
        'ssl_chain'       => $ssl_chain,
      },
    }
  } else {
    # no ssl
    $vhosts = {
      $servername => {
        'serveraliases' => $_serveraliases,
        'port'          => '80',
      },
    }
  }
  $vhost_defaults = merge($vhost_add, {
    'docroot'       => $documentroot,
    'aliases'       => [
      { alias => '/autodiscover/autodiscover.xml',
        path  => "${documentroot}/autodiscover.xml",
      },
      { alias => '/Autodiscover/Autodiscover.xml',
        path  => "${documentroot}/autodiscover.xml",
      },
      { alias => '/mail/config-v1.1.xml',
        path  => "${documentroot}/config-v1.1.xml",
      },
    ],
    custom_fragment => "<Files \"autodiscover.xml\">\n    AddType application/x-httpd-php .xml\n  </Files>",
  })

  create_resources('apache::vhost', $vhosts, $vhost_defaults)

  # create resources
  $create_resources.each | $res, $vals | {
    create_resources($res, $vals )
  }
}
