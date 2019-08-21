
require 'spec_helper'

describe 'autoconfigmail::autoconfig' do
  let :default_params do
    { mailserver: 'mail.cirrax.com',
      documentroot: '/var/www/html',
      incoming: [{ 'type' => 'imap', 'sockettype' => 'STARTTLS', 'port' => '143' }],
      outgoing: [{ 'type' => 'smtp', 'sockettype' => 'STARTTLS', 'port' => '25' }],
      documentation: [{ 'url' => 'http://www.xyz.ch', 'descriptions' => { 'de' => 'webseite' } }],
      provider: 'testmailserver.example.com',
      domain: 'example.com',
      shortname: 'testmailserver',
      displayname: 'Mailserver testmailserver.example.com' }
  end

  shared_examples 'autoconfigmail::autoconfig shared examples' do
    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_concat(params[:documentroot] + '/config-v1.1.xml')
        .with_owner('root')
        .with_group('www-data')
        .with_mode('0644')
    }

    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: header')
        .with_target(params[:documentroot] + '/config-v1.1.xml')
        .with_order('00')
    }
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: footer')
        .with_target(params[:documentroot] + '/config-v1.1.xml')
        .with_order('99')
    }
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: incoming 0')
        .with_target(params[:documentroot] + '/config-v1.1.xml')
        .with_order('40-0')
    }
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: outgoing 0')
        .with_target(params[:documentroot] + '/config-v1.1.xml')
        .with_order('50-0')
    }
    it {
      is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: documentation 0')
        .with_target(params[:documentroot] + '/config-v1.1.xml')
        .with_order('60-0')
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let :params do
          default_params
        end

        it_behaves_like 'autoconfigmail::autoconfig shared examples'
      end

      context 'with different documentroot' do
        let :params do
          default_params.merge(documentroot: '/tmp')
        end

        it_behaves_like 'autoconfigmail::autoconfig shared examples'
      end

      context 'with no services' do
        let :params do
          default_params.merge(
            incoming: [],
            outgoing: [],
            documentation: [],
          )
        end

        it { is_expected.not_to contain_concat__fragment('autoconfigmail::autodiscover: incoming 0') }
        it { is_expected.not_to contain_concat__fragment('autoconfigmail::autodiscover: outgoing 0') }
        it { is_expected.not_to contain_concat__fragment('autoconfigmail::autodiscover: documentation 0') }
        it { is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: header') }
        it { is_expected.to contain_concat__fragment('autoconfigmail::autoconfig: footer') }
      end
    end
  end
end
