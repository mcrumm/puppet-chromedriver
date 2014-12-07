class chromedriver::params {
  $target     = '/usr/local/bin'
  $base_url   = 'http://chromedriver.storage.googleapis.com'
  $base_dir   = '/opt/chromedriver'
  $bin        = 'chromedriver'
  $latest     = 'LATEST_RELEASE'
  $latest_url = "${base_url}/${latest}"

  $bits = $::hardwaremodel ? {
    'x86_64'  => 64,
    default   => 32,
  }

  $archive    = "chromedriver_linux${bits}"
}
