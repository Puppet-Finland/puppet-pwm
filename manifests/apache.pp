#
# @summary
#   Set up Apache for Pwm
#
class pwm::apache {
  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php
  include apache::mod::prefork
}
