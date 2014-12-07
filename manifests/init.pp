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

  $version  = $ensure ? {
    present => latest,
    latest  => latest,
    absent  => latest,
    default => $ensure
  }

  if $ensure == absent {
    file { [
      $base_dir_real,
      "${target_real}/${::chromedriver::params::bin}",
    ]:
      ensure  => $ensure,
      force   => true,
      recurse => true,
    }
  } else {
    if $version == latest {
      ::chromedriver::latest { 'latest':
        target    => $target_real,
        md5       => $md5,
        base_dir  => $base_dir_real,
      }
    }
    else {
      ::chromedriver::version { $version :
        target    => $target_real,
        md5       => $md5,
        base_dir  => $base_dir_real,
      }
    }
  }
}
