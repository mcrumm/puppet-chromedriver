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
#    ensure => 'latest',
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
  $ensure   = present,
  $target   = '/usr/local/bin',
  $md5      = undef,
  $base_url = 'http://chromedriver.storage.googleapis.com',
  $base_dir = '/opt/chromedriver',
) {

  $version  = $ensure ? {
    present => latest,
    latest  => latest,
    absent  => latest,
    default => $ensure
  }

  if $ensure == absent {
    file { [
      $base_dir,
      "${target}/chromedriver",
    ]:
      ensure  => $ensure,
      force   => true,
      recurse => true,
    }
  } else {
    if $version == latest {
      ::chromedriver::latest { 'latest':
        md5       => $md5,
        base_url  => $base_url,
        base_dir  => $base_dir,
      }
    }
    else {
      ::chromedriver::version { $version :
        md5       => $md5,
        base_url  => $base_url,
        base_dir  => $base_dir,
      }
    }
  }
}
