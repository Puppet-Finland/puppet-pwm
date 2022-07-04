#
# @summary install pwm
#
# @param download_url
# @param context
# @param webapps_path
#
class pwm::install (
  Stdlib::HTTPSUrl     $download_url,
  String               $context,
  Stdlib::AbsolutePath $webapps_path,
) {
  $war_path = "${webapps_path}/${context}.war"

  archive { $war_path:
    ensure  => 'present',
    source  => $download_url,
    require => Service['tomcat9'],
  }
}
