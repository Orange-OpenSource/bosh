require 'spec_helper'

describe 'CloudStack Stemcell', stemcell_image: true do
  context 'installed by system_parameters' do
    describe file('/var/vcap/bosh/etc/infrastructure') do
      it { should contain('cloudstack') }
    end
  end

  context 'installed by package_vhd_image stage' do
    describe 'converts to vhd' do
      # environment is cleaned up inside rspec context
      stemcell_image = ENV['STEMCELL_IMAGE']

      subject do
        cmd = "qemu-img info #{File.join(File.dirname(stemcell_image), 'root.vhd')}"
        `#{cmd}`
      end

      # it { should include('compat: 0.10') }
    end
  end

end
