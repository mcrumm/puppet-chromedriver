define chromedriver::latest (
  $md5      = undef,
  $target   = undef,
  $base_dir = undef,
) {

  include chromedriver::params

  $target_real = $target ? {
    undef   => $::chromedriver::params::target,
    default => $target,
  }

  $base_dir_real = $base_dir ? {
    undef   => $::chromedriver::params::base_dir,
    default => $base_dir,
  }

  $latest_path  = "${base_dir_real}/${::chromedriver::params::latest}"

  file { $base_dir_real :
    ensure => 'directory',
  } ->

  exec { 'latest-release':
    command => "curl -s -S -o ${latest_path} ${::chromedriver::params::latest_url}",
  } ->

  ::chromedriver::version { $title :
    version   => file($latest_path),
    target    => $target_real,
    md5       => $md5,
    base_dir  => $base_dir_real,
  }
}
