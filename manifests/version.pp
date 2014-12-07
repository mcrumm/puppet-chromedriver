define chromedriver::version (
  $version  = $title,
  $md5      = undef,
  $base_url = 'http://chromedriver.storage.googleapis.com',
  $base_dir = '/opt/chromedriver'
) {
  include ::unzip

  $bits = $::hardwaremodel ? {
    'x86_64' => 64,
    default  => 32,
  }

  if $md5 != undef {
    $digest = $md5
  }

  $verify_checksum = $digest ? {
    undef   => false,
    default => true
  }

  $archive      = "chromedriver_linux${bits}"
  $url          = "${base_url}/${version}/${archive}.zip"
  $archive_dir  = "${base_dir}/${version}"
  $target_file  = "${archive_dir}/chromedriver"
  $target_link  = "${target}/chromedriver"

  archive { $archive:
    ensure        => present,
    checksum      => $verify_checksum,
    digest_string => $digest,
    extension     => 'zip',
    target        => $archive_dir,
    root_dir      => 'chromedriver',
    url           => $url,
    require       => Class['::unzip'],
  } ->

  file { $target_file:
    mode => '0755',
  } ->

  file { $target_link:
    ensure => 'link',
    target => $target_file,
  }
}
