# frozen_string_literal: true

require 'spec_helper'

describe 'autoconfigmail::vhost::apache' do
  let :default_params do
    { servername: 'foo.bar.com',  }
  end

  let :pre_condition do
    'class { "apache": mpm_module => "prefork" }'
  end

  shared_examples 'autoconfigmail::vhost::apache shared examples' do
    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_apache__vhost(params[:servername])
        .with_port(80)
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults' do
        let :params do
          default_params
        end

        it_behaves_like 'autoconfigmail::vhost::apache shared examples'
      end
    end
  end
end
