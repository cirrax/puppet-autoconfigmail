#
class autoconfigmail::params () {

  $autodiscover_protocols_default = [
    { type => 'IMAP',
      port => '993',
    },
    { type => 'POP3',
      port => '995',
    },
    { type       => 'SMTP',
      port       => '465',
      usepopauth => true,
      smtplast   => 'off',
    },
  ]

  $autoconfig_incoming_default = [
    { type           => 'imap',
      port           => '993',
      sockettype     => 'SSL',
      authentication => 'password-encrypted',
      username       => '%EMAILADDRESS%',
    },
    { type           => 'imap',
      port           => '143',
      sockettype     => 'STARTTLS',
      authentication => 'password-encrypted',
      username       => '%EMAILADDRESS%',
    },
    { type           => 'pop3',
      port           => '995',
      sockettype     => 'SSL',
      authentication => 'password-encrypted',
      username       => '%EMAILADDRESS%',
    },
    { type           => 'pop3',
      port           => '110',
      sockettype     => 'STARTTLS',
      authentication => 'password-encrypted',
      username       => '%EMAILADDRESS%',
    },
  ]

  $autoconfig_outgoing_default = [
    { type           => 'smtp',
      port           => '465',
      sockettype     => 'SSL',
      authentication => 'password-encrypted',
      username       => '%EMAILADDRESS%',
    },
    { type           => 'smtp',
      port           => '587',
      sockettype     => 'STARTTLS',
      authentication => 'password-encrypted',
      username       => '%EMAILADDRESS%',
    },
  ]
  $autoconfig_documentation_default = []
}
