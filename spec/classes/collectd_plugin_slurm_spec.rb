require 'spec_helper'

describe 'collectd::plugin::slurm', type: :class do
  on_supported_os(baseline_os_hash).each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        it "Will create #{options[:plugin_conf_dir]}/10-slurm.conf" do
          is_expected.to contain_file('slurm.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-slurm.conf",
            content: %r{Globals true}m
          )
        end
      end
    end
  end
end
