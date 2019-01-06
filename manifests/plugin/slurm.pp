# https://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_slurm
class collectd::plugin::slurm (
  Enum['present', 'absent'] $ensure = 'present',
  Integer $order                    = 10,
  Optional[Numeric] $interval       = undef,
) {

  include ::collectd

  collectd::plugin { 'slurm':
    ensure   => $ensure,
    order    => $order,
    interval => $interval,
    globals  => true, # slurm libraries assume RTLD_GLOBAL
  }
}
