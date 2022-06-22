#
# @summary
#   Set up OpenJDK for Pwm
#
class pwm::openjdk {

  $obsolete_openjdk_versions = [8,11,13,16]
  $current_version = 17
  $current_package ="openjdk-${current_version}-jre-headless"

  package { $current_package:
    ensure => 'present',
  }

  $obsolete_openjdk_versions.each |$version| {
    package { "openjdk-${version}-jre-headless":
      ensure  => 'absent',
      require => Package[$current_package],
    }
  }
}
