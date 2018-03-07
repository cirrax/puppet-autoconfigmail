# autoconfig puppet module

[![Build Status](https://travis-ci.org/cirrax/puppet-autoconfigmail.svg?branch=master)](https://travis-ci.org/cirrax/puppet-autoconfigmail)
[![Puppet Forge](https://img.shields.io/puppetforge/v/cirrax/autoconfigmail.svg?style=flat-square)](https://forge.puppetlabs.com/cirrax/autoconfigmail)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/cirrax/autoconfigmail.svg?style=flat-square)](https://forge.puppet.com/cirrax/autoconfigmail)
[![Puppet Forge](https://img.shields.io/puppetforge/e/cirrax/autoconfigmail.svg?style=flat-square)](https://forge.puppet.com/cirrax/autoconfigmail)
[![Puppet Forge](https://img.shields.io/puppetforge/f/cirrax/autoconfigmail.svg?style=flat-square)](https://forge.puppet.com/cirrax/autoconfigmail)

#### Table of Contents

1. [Overview](#overview)
1. [Usage](#usage)
1. [Reference](#reference)
1. [Contribuiting](#contributing)


## Overview

This module is used to configure a virtual webhost wich
contains files for autoconfiguring email clients.


## Usage

    include autoconfigmail

To make it work, you need to setup DNS for your maildomains. An example record would look like:

    ; Autoconfig for Thunderbird etc.
    autoconfig                   IN CNAME  your_webserver
    ; Autoconfig for Outlook
    autodiscover._tcp            IN SRV     0 5 80 your_webserver


## Reference

Find a reference of all available parameters in the manifests.

## Todo

add further autoconfigure methods. eg: for iOS / Apple Mail (email.mobileconfig).

## Contributing

Please report bugs and feature request using GitHub issue tracker.

For pull requests, it is very much appreciated to check your Puppet manifest with puppet-lint
and the available spec tests  in order to follow the recommended Puppet style guidelines
from the Puppet Labs style guide.

### Authors

This module is mainly written by [Cirrax GmbH](https://cirrax.com).

See the [list of contributors](https://github.com/cirrax/puppet-autoconfigmail/graphs/contributors)
for a list of all contributors.
