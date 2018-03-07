#
# This class implements autodiscover
# by creating a XML file with available mail services
#
# For details about autodiscover see:
# http://technet.microsoft.com/en-us/library/bb124251.aspx
# and 
# http://msdn.microsoft.com/en-us/library/dd899340%28v=exchg.140%29
#
# Parameters:
#   $mailserver
#     the mailserver to connect to
#     defaults to: $autoconfigmail::mailserver
#     Remark: if you specify 'hostname' on $incoming/$outgoing
#     Hash, you can overwrite this default for specified service.
# 
#  $documentroot
#    the document root, where to place the file
#    defaults to: $autoconfigmail::documentroot
#  $protocols
#    Array of Hashes of services available for incoming mail
#    defaults to $autoconfigmail::autodiscover_protocols
#
#    Example in hiera for imap service:
#    autoconfigmail::autodiscover::protocols:
#      - type: 'IMAP'
#        port: '993'
#
class autoconfigmail::autodiscover (
  String $mailserver   = $autoconfigmail::mailserver,
  String $documentroot = $autoconfigmail::documentroot,
  Array  $protocols    = $autoconfigmail::autodiscover_protocols,
) inherits ::autoconfigmail {

  concat { "${documentroot}/autodiscover.xml" :
    owner => 'root',
    group => 'www-data',
    mode  => '0644',
  }

  concat::fragment {'autoconfigmail::autodiscover: header':
    target  => "${documentroot}/autodiscover.xml",
    content => epp('autoconfigmail/autodiscover/header.epp', { mailserver => $mailserver }),
    order   => '00',
  }

  $protocols.each | Integer $key, Hash $val | {
    concat::fragment {"autoconfigmail::autodiscover: protocol ${key}":
      target  => "${documentroot}/autodiscover.xml",
      content => epp('autoconfigmail/autodiscover/protocol.epp', $val),
      order   => "50-${key}",
    }
  }

  concat::fragment {'autoconfigmail::autodiscover: footer':
    target  => "${documentroot}/autodiscover.xml",
    content => epp('autoconfigmail/autodiscover/footer.epp'),
    order   => '99',
  }

}
