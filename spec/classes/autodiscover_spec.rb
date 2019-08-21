
require 'spec_helper'

describe 'autoconfigmail::autodiscover' do
  let :facts do
    {
      fqdn: 'testmailserver.example.com',
      domain: 'example.com',
      hostname: 'testmailserver',
    }
  end

  let :default_params do
    { mailserver: 'testmailserver.example.com',
      documentroot: '/var/www/html',
      protocols: [{ 'type' => 'imap', 'port' => '143' }] }
  end

  shared_examples 'autoconfigmail::autodiscover shared examples' do
    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_concat(params[:documentroot] + '/autodiscover.xml')
        .with_owner('root')
        .with_group('www-data')
        .with_mode('0644')
    }

    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: header')
        .with_target(params[:documentroot] + '/autodiscover.xml')
        .with_order('00')
    }
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: footer')
        .with_target(params[:documentroot] + '/autodiscover.xml')
        .with_order('99')
    }
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: protocol 0')
        .with_target(params[:documentroot] + '/autodiscover.xml')
        .with_order('50-0')
    }
  end

  context 'with defaults' do
    let :params do
      default_params
    end

    it_behaves_like 'autoconfigmail::autodiscover shared examples'
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: header')
        .with_content(%r{\$mailserver = 'testmailserver.example.com';})
    }
  end

  context 'with different mailserver' do
    let :params do
      default_params.merge(mailserver: 'foobar.foo.foo')
    end

    it_behaves_like 'autoconfigmail::autodiscover shared examples'
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: header')
        .with_content(%r{\$mailserver = 'foobar.foo.foo';})
    }
  end

  context 'with different documentroot' do
    let :params do
      default_params.merge(documentroot: '/tmp')
    end

    it_behaves_like 'autoconfigmail::autodiscover shared examples'
  end

  context 'with no services' do
    let :params do
      default_params.merge(
        protocols: [],
      )
    end

    it { is_expected.not_to contain_concat__fragment('autoconfigmail::autodiscover: protocol 0') }
    it { is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: header') }
    it { is_expected.to contain_concat__fragment('autoconfigmail::autodiscover: footer') }
  end
end
