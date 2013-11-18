# natives

[![Gem Version](https://badge.fury.io/rb/natives.png)](http://badge.fury.io/rb/natives)
[![Code Climate](https://codeclimate.com/github/teohm/natives.png)](https://codeclimate.com/github/teohm/natives)
[![Build Status](https://travis-ci.org/teohm/natives.png)](https://travis-ci.org/teohm/natives)
[![Dependency Status](https://gemnasium.com/teohm/natives.png)](https://gemnasium.com/teohm/natives)

List native packages required by ruby gems on your machine.

What it does:

* maintains a [multi-platform catalog](https://github.com/teohm/natives-catalog/blob/master/catalogs/rubygems.yaml) of native packages for ruby gems.
* detects platform, platform version using [Chef Ohai](https://github.com/opscode/ohai).
* detects package manager.
* returns a list of native packages based on the gems specified by you or a gemfile.


## Install

```
gem install natives
```

## Use

```
natives list capybara-webkit sqlite3
```

### Have a gemfile?

```
natives list  # looks for Gemfile in current directory
natives list --gemfile Gemfile.special
natives list --gemfile /path/to/Gemfile.special
```

### How to install native packages?

Output from `natives list` can be used together with your package manager e.g. `brew`, `apt-get`. If you need a package manager wrapper, try [pacapt](https://github.com/icy/pacapt).

```
brew install $(natives list capybara-webkit sqlite3)
apt-get install $(natives list capybara-webkit sqlite3)
pacapt -S $(natives list capybara-webkit sqlite3)
```

### Switch catalog
It uses 'rubygems' catalog by default. To use a different catalog:

```
natives list --catalog npm sqlite3
```

### Custom (project-specific) catalog
It also looks for `natives-catalogs/` in current directory. If exists, it loads all catalog files in the directory.

```
$ cd rails_app1
$ cat natives-catalogs/catalog1.yaml
rubygems:
  my_gem:
    homebrew:
      mac_os_x:
        - package1
    apt:
      default:
        - package2

$ natives list my_gem   # runs on mac os x
package1
```

## Catalog

### Supported catalogs

* **[rubygems](https://github.com/teohm/natives-catalog/blob/master/catalogs/rubygems.yaml) <-- calling for contributions! :-)**
* new catalog contributions e.g. for "npm" are welcomed too! Just submit your PR.

### Catalog load paths

It loads YAML files (.yaml, .yml) from the following paths in this order:

1. `catalogs/` in this gem.
2. `natives-catalogs/` in current working directory, if any.

When there are multiple YAML files in a path, they are **sorted by filename** and loaded in that order.

### Catalog YAML format

A catalog file is written in YAML, based on this format:

```
catalog_name:
  entry_name:
    package_provider:
      platform:
        platform_version:
          - package_name
```

For example,

```
rubygems:
  capybara-webkit:
    homebrew:
      mac_os_x:
        10.7.5:
          - libqtwebkit-dev
```

#### Use `default` when apply to all platforms

```
rubygems:
  curb:
    apt:
      default:
        - libcurl4-openssl-dev

```

#### Use `default` when apply to all platform versions

```
rubygems:
  capybara-webkit:
    homebrew:
      mac_os_x:
        default:
          - libqtwebkit-dev
```

#### Use array to group platform versions

```
rubygems:
  capybara-webkit:
    apt:
      ubuntu:
        [10.04, 10.04.1, 10.04.2, 10.04.3, 10.04.4]:
          - libqt4-dev
        default:
          - libqtwebkit-dev
```


#### Supported values for platforms and package providers

Not in the list? No worry, submit a PR to patch [`host_detection/package_provider.rb`](https://github.com/teohm/natives/blob/master/lib/natives/host_detection/package_provider.rb).

##### Package providers
```
aix
yum
packman
apt
feebsd
portage
homebrew
macports
solaris
ips
zypper
smartos
```

##### Platforms
```
aix
amazon
arch
centos
debian
fedora
freebsd
gcel
gentoo
linaro
linuxmint
mac_os_x
mac_os_x_server
nexentacore
omnios
openindiana
opensolaris
opensuse
oracle
raspbian
redhat
scientific
smartos
solaris2
suse
ubuntu
xcp
xenserver
```


## Contributing to natives

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Huiming Teo. See LICENSE.txt for
further details.

