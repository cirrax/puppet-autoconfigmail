
require 'spec_helper'

describe 'autoconfigmail::params' do
  shared_examples 'autoconfigmail::params shared examples' do
    it { is_expected.to compile.with_all_deps }
  end

  context 'with defaults' do
    it_behaves_like 'autoconfigmail::params shared examples'
  end
end
