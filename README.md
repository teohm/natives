# natives-catalog

Maintains a catalog of native library packages required by Ruby gems, and a parser to load catalog files.

It can be extended to maintain additional catalogs e.g. for other package dependency manager such as `npm`.

It is currently used by [natives](https://github.com/teohm/natives) gem to install native packages on multiple platforms.

### Calling for ruby gems catalog contributors!

Your pull requests are welcomed to maintain the [rubygems catalog](https://github.com/teohm/natives-catalog/blob/master/catalogs/rubygems.yaml) and keep it up-to-date! 

## Install

```
gem install natives-catalog
```

## Use

```
require 'natives/catalog'

catalog = Natives::Catalog.new(
  'rubygems',
  'mac_os_x', '10.7.5',
  'homebrew')
  
catalog.to_hash  # returns the loaded catalog hash

catalog.reload   # reloads catalog files

catalog.native_packages_for('webcapybara', 'sqlite3')
# => ["qt", "sqlite"]
```


## Catalog

### Supported catalogs

* **[rubygems](https://github.com/teohm/natives-catalog/blob/master/catalogs/rubygems.yaml) (calling for your PR contributions!)**
* (new catalog contributors e.g. for `npm` are welcomed :-)

### Catalog load paths

It loads YAML files (.yaml, .yml) from the following paths in this order:

1. `catalogs/` in this gem.
2. `natives-catalogs/` in current working directory, if any.

When there are several YAML files in a path, they are **sorted by filename** and loaded in the same order.

### Catalog file format

A catalog file is written in YAML, based on this format:

```
catalog_name:
  entry_name:
    platform/package_provider:
      version:
        - package_name
```

For example,

```
rubygems:
  capybara-webkit:
    mac_os_x/homebrew:
      10.7.5:
        - libqtwebkit-dev
```

#### Use `default` when apply to all platforms

```
rubygems:
  curb:
    default:
      - curl
```

#### Use `default` when apply to all versions

```
rubygems:
  capybara-webkit:
    mac_os_x/homebrew:
      default:
        - libqtwebkit-dev
```

#### Use array to group platforms

```
rubygems:
  capybara-webkit:
    [ubuntu/apt, debian/apt]:
      default:
        - libqtwebkit-dev
```

#### Use array to group versions



```
rubygems:
  capybara-webkit:
    ubuntu/apt:
      [10.04, 10.04.1, 10.04.2, 10.04.3, 10.04.4]:
        - libqt4-dev
      default:
        - libqtwebkit-dev
```


#### Supported values for platform/package_provider

The values are limited to the platforms and package providers [supported by Chef](https://github.com/opscode/chef/blob/master/lib/chef/platform/provider_mapping.rb), so that Chef can be used to perform the package installation (see [natives](https://github.com/teohm/natives) gem).

```
aix/aix
amazon/yum
arch/pacman
centos/yum
debian/apt
fedora/yum
freebsd/freebsd
gcel/apt
gentoo/portage
linaro/apt
linuxmint/apt
mac_os_x/homebrew
mac_os_x/macports
mac_os_x_server/macports
nexentacore/solaris
omnios/ips
openindiana/ips
opensolaris/ips
opensuse/zypper
oracle/yum
raspbian/apt
redhat/yum
scientific/yum
smartos/smartos
solaris2/ips
suse/zypper
ubuntu/apt
xcp/yum
xenserver/yum
```


## Contributing to natives-catalog

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

