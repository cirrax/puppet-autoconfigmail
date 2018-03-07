
require 'spec_helper'

describe 'autoconfigmail' do
  let :pre_condition do
    'class { "apache": mpm_module => "prefork" }'
  end


  let :facts do
    {
      :operatingsystemrelease => 'test',
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :lsbdistcodename        => 'Debian',
    }
  end

  let :default_params do
      { :mailserver               => 'hostname',
	:documentroot             => '/var/www/html',
	:enable_autodiscover      => true,
	:enable_autoconfig        => true,
	:vhost_type               => 'none',
	:autoconfig_incoming      => [],
	:autoconfig_outgoing      => [],
	:autoconfig_documentation => [],
	:autodiscover_protocols   => [],
      }
  end

  shared_examples 'autoconfigmail shared examples' do
    it { is_expected.to compile.with_all_deps }
  end

  context 'with defaults' do
    let :params do
      default_params
    end
    it_behaves_like 'autoconfigmail shared examples'

    it { is_expected.to contain_class('autoconfigmail::autodiscover') }
    it { is_expected.to contain_class('autoconfigmail::autoconfig') }
    it { is_expected.to_not contain_class('autoconfigmail::vhost::apache') }
  end

  context 'without autodiscover' do
    let :params do
      default_params.merge( :enable_autodiscover => false )
    end
    it_behaves_like 'autoconfigmail shared examples'

    it { is_expected.to_not contain_class('autoconfigmail::autodiscover') }
    it { is_expected.to contain_class('autoconfigmail::autoconfig') }
    it { is_expected.to_not contain_class('autoconfigmail::vhost::apache') }
  end

  context 'without autoconfig' do
    let :params do
      default_params.merge( :enable_autoconfig => false )
    end
    it_behaves_like 'autoconfigmail shared examples'

    it { is_expected.to contain_class('autoconfigmail::autodiscover') }
    it { is_expected.to_not contain_class('autoconfigmail::autoconfig') }
    it { is_expected.to_not contain_class('autoconfigmail::vhost::apache') }
  end

  context 'with apache vhost' do
    let :params do
      default_params.merge( :vhost_type => 'apache' )
    end
    it_behaves_like 'autoconfigmail shared examples'

    it { is_expected.to contain_class('autoconfigmail::autodiscover') }
    it { is_expected.to contain_class('autoconfigmail::autoconfig') }
    it { is_expected.to contain_class('autoconfigmail::vhost::apache') }
  end
end

