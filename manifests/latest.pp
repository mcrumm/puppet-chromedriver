define chromedriver::latest (
  $md5            = undef,
  $base_dir       = '/opt/chromedriver',
  $base_url       = 'http://chromedriver.storage.googleapis.com'
) {

  $latest_file    = 'LATEST_RELEASE'
  $latest_path    = "${target}/${latest_file}"

  file { $target :
    ensure => 'directory',
  } ->

  exec { 'latest-release':
    command => "curl -s -S -o ${latest_path} ${base_url}/${latest_file}",
  } ->

  ::chromedriver::version { 'latest':
    version   => file($latest_path),
    md5       => $md5,
    base_dir  => $base_dir,
    base_url  => $base_url,
  }
}
