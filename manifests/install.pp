#
# == Class: pwm::install
#
# Install pwm
#
class pwm::install
(
    Boolean          $build,
    Optional[String] $war_source = undef,
    Optional[String] $build_user = undef,

) inherits pwm::params {

    if $build {

        ensure_packages($::pwm::params::build_deps, { 'ensure' => 'present' })

        # Build cannot continue unless $build_user is defined
        unless $build_user {
            fail('ERROR: $build_user is not defined, cannot continue with the build!')
        }

        if $build_user == 'root' {
            fail('ERROR: building pwm as root user does not work! Please use a normal user.')
        }

        $source_dir = "${::os::params::home}/${build_user}/pwm"
        $war_file = "${source_dir}/server/target/pwm-1.8.0-SNAPSHOT.war"

        vcsrepo { $source_dir:
            ensure   => 'present',
            provider => 'git',
            source   => 'https://github.com/pwm-project/pwm.git',
            user     => $build_user,
        }

        exec { 'build pwm':
            command   => 'mvn package',
            cwd       => $source_dir,
            logoutput => true,
            timeout   => '3600',
            user      => $build_user,
            path      => ['/bin','/usr/bin','/usr/local/bin'],
            creates   => $war_file,
        }

    } else {
        unless $war_source {
            fail('ERROR: $war_source must defined if $build is false!')
        }
        $war_file = $war_source
    }

    # Use the Tomcat module to install pwm.war
    tomcat::war { 'pwm':
        source  => $war_file,
        require => Class['::tomcat'], 
    }
}
