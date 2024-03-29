# This class implements autoconfig
# by creating a XML file whit the mail configuration
#
# For details about autoconfig see:
# https://developer.mozilla.org/en-US/docs/Thunderbird/Autoconfiguration
# and:
# https://developer.mozilla.org/en-US/docs/Thunderbird/Autoconfiguration/FileFormat/HowTo.
#
# @param mailserver
#   the mailserver to connect to
#   defaults to: $autoconfigmail::mailserver
#   Remark: if you specify 'hostname' on $incoming/$outgoing
#   Hash, you can overwrite this default for specified service.
# @param documentroot
#   the document root, where to place the file
#   defaults to: $autoconfigmail::documentroot
# @param incoming
#   Array of Hashes of services available for incoming mail
#   defaults to $autoconfigmail::autoconfig_incoming
#
#   Example in hiera for imap service:
#     autoconfigmail::autooconfig::incoming:
#       - type:           'imap'
#         port:           '143'
#         sockettype:     'STARTTLS'
#         authentication: 'password-encrypted'
#         username:       '%EMAILADDRESS%'  # use if you login without domain %EMAILLOCALPART%
#
#   Remark: if you specify hostname, you can overwrite the default
#   $mailserver for a service.
# @param outgoing
#   Array of Hashes of services available for sending mail
#   defaults to $autoconfigmail::autoconfig_outgoing
#
#   Example in hiera for smtp service:
#     # Remark: if authentication/username is not specified,
#     # default is taken.
#     autoconfigmail::autoconfig::outgoing:
#       - type:           'smtp'
#         port:           '25'
#         sockettype:     'STARTTLS'
#         authentication: 'password-encrypted'
#         username:       '%EMAILADDRESS%'  # use if you login without domain %EMAILLOCALPART%
#
#   Remark: if you specify hostname, you can overwrite the default
#   $mailserver for a service.
# @param documentation = $autoconfigmail::autoconfig_documentation_default,
#   Array of Hashes to specify Url's about mail.
#     autoconfigmail::autoconfig::documentation:
#       - url: 'https://www.cirrax.com'
#         descriptions:
#           de: 'Cirrax Webseite'
#           en: 'Website of Cirrax'
# @param provider
#   id of the email provider (defaults to $::fqdn)
# @param domain
#   domain of the email provider (defaults to $::domain)
# @param shortname
#   shortname of the email provider (defaults to $::hostname)
# @param displayname
#   diplayname of the email provider (defaults to "Mailserver ${::fqdn}")
# @param default_authentication
#   default authentication to take for incoming and outgoing if not
#   specified there
# @param default_username
#   default username to take for incoming and outgoing if not
#   specified there
#
class autoconfigmail::autoconfig (
  String $mailserver             = $autoconfigmail::mailserver,
  String $documentroot           = $autoconfigmail::documentroot,
  Array  $incoming               = $autoconfigmail::autoconfig_incoming,
  Array  $outgoing               = $autoconfigmail::autoconfig_outgoing,
  Array  $documentation          = $autoconfigmail::autoconfig_documentation,
  String $provider               = $facts['networking']['fqdn'],
  String $domain                 = $facts['networking']['domain'],
  String $shortname              = $facts['networking']['hostname'],
  String $displayname            = "Mailserver ${facts['networking']['fqdn']}",
  String $default_authentication = 'password-encrypted',
  String $default_username       = '%EMAILADDRESS%',
) inherits autoconfigmail {
  concat { "${documentroot}/config-v1.1.xml" :
    owner => 'root',
    group => 'www-data',
    mode  => '0644',
  }

  concat::fragment { 'autoconfigmail::autoconfig: header':
    target  => "${documentroot}/config-v1.1.xml",
    content => epp('autoconfigmail/autoconfig/header.epp',
      { provider    => $provider,
        domain      => $domain,
        shortname   => $shortname,
        displayname => $displayname,
      }
    ),
    order   => '00',
  }

  $incoming.each | Integer $key, Hash $val | {
    concat::fragment { "autoconfigmail::autoconfig: incoming ${key}":
      target  => "${documentroot}/config-v1.1.xml",
      content => epp('autoconfigmail/autoconfig/incoming.epp',
        { hostname       => $mailserver,
          authentication => $default_authentication,
          username       => $default_username,
      } + $val ),
      order   => "40-${key}",
    }
  }

  $outgoing.each | Integer $key, Hash $val | {
    concat::fragment { "autoconfigmail::autoconfig: outgoing ${key}":
      target  => "${documentroot}/config-v1.1.xml",
      content => epp('autoconfigmail/autoconfig/outgoing.epp',
        { hostname       => $mailserver,
          authentication => $default_authentication,
          username       => $default_username,
      } + $val ),
      order   => "50-${key}",
    }
  }

  $documentation.each | Integer $key, Hash $val | {
    concat::fragment { "autoconfigmail::autoconfig: documentation ${key}":
      target  => "${documentroot}/config-v1.1.xml",
      content => epp('autoconfigmail/autoconfig/documentation.epp', $val ),
      order   => "60-${key}",
    }
  }

  concat::fragment { 'autoconfigmail::autoconfig: footer':
    target  => "${documentroot}/config-v1.1.xml",
    content => epp('autoconfigmail/autoconfig/footer.epp'),
    order   => '99',
  }
}
