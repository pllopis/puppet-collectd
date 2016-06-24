require 'spec_helper'

describe 'collectd::plugin::curl', type: :class do
  let :pre_condition do
    'include ::collectd'
  end
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0'
    }
  end

  context ':ensure => present, default params' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '4.8.0'
      }
    end
    it 'Will create /etc/collectd.d/10-curl.conf' do
      should contain_file('curl.load').with(ensure: 'present',
                                            path: '/etc/collectd.d/10-curl.conf',
                                            content: %r{\#\ Generated by Puppet\nLoadPlugin curl\n\n})
    end
  end

  context ':ensure => present, creating two pages' do
    let :facts do
      {
        osfamily: 'Debian',
        collectd_version: '4.8.0'
      }
    end
    let :params do
      {
        ensure: 'present',
        pages: {
          'stocks_ILD' => {
            'url'      => 'http://finance.google.com/finance?q=EPA%3AILD',
            'user'     => 'foo',
            'password' => 'bar',
            'matches'  => [
              {
                'dstype'   => 'GaugeAverage',
                'instance' => 'ILD',
                'regex'    => ']*> *([0-9]*\\.[0-9]+) *',
                'type'     => 'stock_value'
              }
            ]
          }
        }
      }
    end

    it 'Will create /etc/collectd.d/conf.d/curl-stocks_ILD.conf and /etc/collectd/conf.d/curl-stocks_GM.conf' do
      should contain_file('/etc/collectd/conf.d/curl-stocks_ILD.conf').with(ensure: 'present',
                                                                            path: '/etc/collectd/conf.d/curl-stocks_ILD.conf',
                                                                            content: "<Plugin curl>\n  <Page \"stocks_ILD\">\n    URL \"http://finance.google.com/finance?q=EPA%3AILD\"\n    User \"foo\"\n    Password \"bar\"\n  <Match>\n    Regex \"]*> *([0-9]*\\.[0-9]+) *\"\n    DSType \"GaugeAverage\"\n    Type \"stock_value\"\n    Instance \"ILD\"\n  </Match>\n\n  </Page>\n</Plugin>\n") # rubocop:disable Metrics/LineLength
    end
  end

  context ':ensure => present, verifypeer => false, verifyhost => \'false\', measureresponsetime => true, matches empty' do
    let :facts do
      {
        osfamily: 'Debian',
        collectd_version: '4.8.0'
      }
    end
    let :params do
      {
        ensure: 'present',
        pages: {
          'selfsigned_ssl' => {
            'url'                 => 'https://some.selfsigned.ssl.site/',
            'verifypeer'          => false,
            'verifyhost'          => 'false',
            'measureresponsetime' => true
          }
        }
      }
    end

    it 'Will create /etc/collectd.d/conf.d/curl-selfsigned_ssl.conf' do
      should contain_file('/etc/collectd/conf.d/curl-selfsigned_ssl.conf').with(ensure: 'present',
                                                                                path: '/etc/collectd/conf.d/curl-selfsigned_ssl.conf',
                                                                                content: "<Plugin curl>\n  <Page \"selfsigned_ssl\">\n    URL \"https://some.selfsigned.ssl.site/\"\n    VerifyPeer false\n    VerifyHost false\n    MeasureResponseTime true\n  </Page>\n</Plugin>\n")
    end
  end

  context ':ensure => absent' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '4.8.0'
      }
    end
    let :params do
      { ensure: 'absent' }
    end

    it 'Will not create /etc/collectd.d/10-curl.conf' do
      should contain_file('curl.load').with(ensure: 'absent',
                                            path: '/etc/collectd.d/10-curl.conf')
    end
  end
end
