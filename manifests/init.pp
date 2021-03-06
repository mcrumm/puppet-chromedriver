# == Class: chromedriver
#
# Installs (or removes) Chrome Driver
#
# === Parameters
#
# [*ensure*]
#   Any of the typical $ensure values for a Package: present, absent,
#   latest, etc.
#
# [*target*]
#   The target directory. Default: /usr/local/bin
#
# [*target*]
#   The target directory. Default: /usr/local/bin
#
# === Examples
#
#  class { 'chromedriver':
#    ensure => '2.10',
#  }
#
# === Authors
#
# Rick Fletcher <fletch@pobox.com>
#
# === Copyright
#
# Copyright 2014 Rick Fletcher
#
# == Class: chromedriver
#
# Download and install chromedriver (WebDriver for Google Chrome)
#
# Parameters:
#
# - $ensure: present, latest, absent, a specific version, etc.
# - $target: directory to install into (default: '/usr/local/bin')
#
# Example usage:
#
# include chromedriver
#
# class { 'chromedriver':
#   ensure => '2.10'
# }
class chromedriver (
  $ensure = present,
  $target = '/usr/local/bin',
  $md5    = undef,
) {
  $bits = $::hardwaremodel ? {
    "x86_64" => 64,
    default  => 32,
  }

  $latest_version = '2.11'
  $latest_md5 = {
    "32" => "bf0d731cd34fd07e22f4641c9aec8483",
    "64" => "7a7336caea140f6ac1cb8fae8df50d36",
  }

  $version = $ensure ? {
    present => $latest_version,
    latest  => $latest_version,
    absent  => $latest_version,
    default => $ensure 
  }

  $archive     = "chromedriver_linux${bits}"
  $url         = "http://chromedriver.storage.googleapis.com/${version}/${archive}.zip"
  $base_dir    = "/opt/chromedriver"
  $archive_dir = "${base_dir}/${version}"
  $target_file = "${archive_dir}/chromedriver"
  $target_link = "${target}/chromedriver"

  if $md5 != undef {
    $digest = $md5
  } elsif $version == $latest_version {
    $digest = $latest_md5[$bits]
  }

  if $digest {
    $verify_checksum = true
  } else {
    $verify_checksum = false
  }

  if $ensure == absent {
    file { [
      $base_dir,
      $target_link,
    ]:
      ensure  => $ensure,
      force   => true,
      recurse => true,
    }
  } else {
    include ::unzip

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
}
