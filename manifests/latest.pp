define chromedriver::latest (
  $target         = '/opt/chromedriver',
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
    version => file($latest_path)
  }
}
