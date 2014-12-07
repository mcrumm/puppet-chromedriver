define chromedriver::version (
  $version  = $title,
  $target   = undef,
  $md5      = undef,
  $base_dir = undef,
) {
  include ::unzip
  include chromedriver::params

  $target_real = $target ? {
    undef   => $::chromedriver::params::target,
    default => $target,
  }

  $base_dir_real = $base_dir ? {
    undef   => $::chromedriver::params::base_dir,
    default => $base_dir,
  }

  if $md5 != undef {
    $digest = $md5
  }

  $verify_checksum = $digest ? {
    undef   => false,
    default => true
  }

  $version_url  = "${::chromedriver::params::base_url}/${version}"
  $target_file  = "${archive_dir}/${::chromedriver::params::bin}"
  $target_link  = "${target_real}/${::chromedriver::params::bin}"

  archive { $::chromedriver::params::archive:
    ensure        => present,
    checksum      => $verify_checksum,
    digest_string => $digest,
    extension     => 'zip',
    target        => "${base_dir_real}/${version}",
    root_dir      => $::chromedriver::params::bin,
    url           => "${version_url}/${::chromedriver::params::archive}.zip",
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
